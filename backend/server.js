const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3300; 
const serverIp = 'localhost'; 

const RESERVED_KEYWORDS = ['admin', 'portal', 'tolong'];

const LATEST_APP_INFO = {
  "version": "1.0.5", 
  "url": `http://${serverIp}:${port}/downloads/UtamaPortal-1.0.5.exe`
};

app.use(cors());
app.use(bodyParser.json());

const uploadDir = path.join(__dirname, 'uploads/icons');
const helpImageDir = path.join(__dirname, 'uploads/help');
const downloadDir = path.join(__dirname, 'downloads');

fs.mkdirSync(uploadDir, { recursive: true });
fs.mkdirSync(helpImageDir, { recursive: true });
fs.mkdirSync(downloadDir, { recursive: true });

app.use('/icons', express.static(uploadDir));
app.use('/help', express.static(helpImageDir));
app.use('/downloads', express.static(downloadDir));

const createMulterStorage = (destination) => {
  return multer.diskStorage({
    destination: (req, file, cb) => cb(null, destination),
    filename: (req, file, cb) => cb(null, `${Date.now()}-${file.originalname}`)
  });
};
const uploadIcon = multer({ storage: createMulterStorage(uploadDir) });
const uploadHelpImage = multer({ storage: createMulterStorage(helpImageDir) });

const pool = mysql.createPool({
  connectionLimit: 10, 
  host: '192.168.10.100', 
  user: 'upm',
  password: 'G4asaru123!',
  database: 'portal_db'
});

pool.getConnection((err, connection) => {
  if (err) {
    console.error('Error connecting to database pool:', err);
    return;
  }
  console.log('Successfully connected to the database pool.');
  connection.release();
});

function validateAppName(appName) {
  const normalizedName = appName.toLowerCase().trim();
  const nameWithoutSpaces = normalizedName.replace(/\s+/g, '');
  
  for (const keyword of RESERVED_KEYWORDS) {
    if (normalizedName === keyword || nameWithoutSpaces === keyword) {
      return {
        isValid: false,
        message: `Nama aplikasi "${appName}" tidak bisa digunakan karena bentrok dengan sistem. Gunakan nama lain.`
      };
    }
  }
  
  return { isValid: true };
}

function validateAppGroup(appGroup) {
  const regex = /^\d+_(main|utility)$/;
  
  if (!regex.test(appGroup)) {
    return {
      isValid: false,
      message: `App group "${appGroup}" tidak valid. Format harus: {category_id}_main atau {category_id}_utility (contoh: 1_main, 2_utility)`
    };
  }
  
  return { isValid: true };
}

app.get('/api/categories', (req, res) => {
  const sql = 'SELECT * FROM categories ORDER BY display_order';
  pool.query(sql, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results);
  });
});

app.post('/api/categories', (req, res) => {
  const { id, name, keyword, background_color, display_order } = req.body;
  
  if (id) {
    const sql = 'UPDATE categories SET name = ?, keyword = ?, background_color = ?, display_order = ? WHERE id = ?';
    pool.query(sql, [name, keyword, background_color, display_order, id], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.status(200).json({ message: 'Category updated', id });
    });
  } else {
    const sql = 'INSERT INTO categories (name, keyword, background_color, display_order) VALUES (?, ?, ?, ?)';
    pool.query(sql, [name, keyword, background_color, display_order || 0], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.status(201).json({ message: 'Category created', id: result.insertId });
    });
  }
});

app.delete('/api/categories/:id', (req, res) => {
  const categoryId = req.params.id;
  
  const deleteAppsSql = 'DELETE FROM applications WHERE app_group LIKE ?';
  pool.query(deleteAppsSql, [`${categoryId}_%`], (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database error' });
    }
    
    const deleteCategorySql = 'DELETE FROM categories WHERE id = ?';
    pool.query(deleteCategorySql, [categoryId], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json({ message: 'Category and its apps deleted' });
    });
  });
});

app.get('/api/app-version', (req, res) => {
  res.json(LATEST_APP_INFO);
});

app.get('/api/reserved-keywords', (req, res) => {
  res.json({ reserved_keywords: RESERVED_KEYWORDS });
});

app.get('/api/installs/count', (req, res) => {
  const query = 'SELECT COUNT(*) as total_installs FROM installations';
  pool.query(query, (err, results) => {
    if (err) {
      console.error("Error getting install count:", err);
      return res.status(500).json({ error: 'Failed to get install count.' });
    }
    const count = results[0] ? results[0].total_installs : 0;
    res.json({ total_installs: count });
  });
});

app.post('/api/installs/ping', (req, res) => {
  const { pc_id } = req.body;
  if (!pc_id) {
    return res.status(400).json({ error: 'pc_id is required' });
  }
  const selectQuery = 'SELECT * FROM installations WHERE pc_id = ?';
  pool.query(selectQuery, [pc_id], (err, results) => {
    if (err) {
      console.error("Error finding installation:", err);
      return res.status(500).json({ error: 'Database query failed.' });
    }
    if (results.length > 0) {
      const updateQuery = 'UPDATE installations SET last_seen_at = NOW() WHERE pc_id = ?';
      pool.query(updateQuery, [pc_id], (err, result) => {
        if (err) return res.status(500).json({ error: 'Database update failed.' });
        res.status(200).json({ message: 'Ping received for existing PC.' });
      });
    } else {
      const insertQuery = 'INSERT INTO installations (pc_id, first_seen_at, last_seen_at) VALUES (?, NOW(), NOW())';
      pool.query(insertQuery, [pc_id], (err, result) => {
        if (err) return res.status(500).json({ error: 'Database insert failed.' });
        res.status(201).json({ message: 'New PC registered.' });
      });
    }
  });
});

app.post('/api/upload/icon', uploadIcon.single('iconFile'), (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }
  const iconUrl = `http://${serverIp}:${port}/icons/${req.file.filename}`;
  res.json({ iconUrl: iconUrl });
});

app.post('/api/upload/help-image', uploadHelpImage.single('helpImageFile'), (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }
  const imageUrl = `http://${serverIp}:${port}/help/${req.file.filename}`;
  res.json({ imageUrl: imageUrl });
});

app.get('/api/data', (req, res) => {
  let responseData = {};
  
  const settingsQuery = 'SELECT * FROM settings';
  pool.query(settingsQuery, (err, settingsResults) => {
    if (err) {
      console.error("Error fetching settings:", err);
      return res.status(500).json({ error: 'Failed to fetch settings.' });
    }
    const settingsObject = {};
    settingsResults.forEach(row => {
      settingsObject[row.setting_key] = row.setting_value;
    });
    responseData.settings = settingsObject;

    const categoriesQuery = 'SELECT * FROM categories ORDER BY display_order';
    pool.query(categoriesQuery, (err, categoriesResults) => {
      if (err) {
        console.error("Error fetching categories:", err);
        return res.status(500).json({ error: 'Failed to fetch categories.' });
      }
      responseData.categories = categoriesResults;

      const appsQuery = 'SELECT * FROM applications ORDER BY display_order ASC';
      pool.query(appsQuery, (err, appsResults) => {
        if (err) {
          console.error("Error fetching applications:", err);
          return res.status(500).json({ error: 'Failed to fetch applications.' });
        }
        responseData.applications = appsResults;
        responseData.reserved_keywords = RESERVED_KEYWORDS;
        
        res.json(responseData);
      });
    });
  });
});

app.post('/api/apps', (req, res) => {
  const apps = req.body.applications;
  if (!apps || !Array.isArray(apps)) {
    return res.status(400).send('Invalid data format.');
  }
  
  for (const app of apps) {
    const nameValidation = validateAppName(app.name);
    if (!nameValidation.isValid) {
      return res.status(400).json({ error: nameValidation.message });
    }
    
    const groupValidation = validateAppGroup(app.app_group);
    if (!groupValidation.isValid) {
      return res.status(400).json({ error: groupValidation.message });
    }
  }
  
  const truncateQuery = 'TRUNCATE TABLE applications';
  pool.query(truncateQuery, (err, result) => {
    if (err) {
      console.error("Error truncating applications table:", err);
      return res.status(500).json({ error: 'Failed to clear applications.' });
    }
    if (apps.length === 0) {
      return res.status(201).send('Applications cleared successfully.');
    }
    const insertQuery = 'INSERT INTO applications (name, description, icon_path, executable_path, border_color_hex, app_group, display_order) VALUES ?';
    const values = apps.map(app => [
      app.name, app.description, app.icon_path, app.executable_path,
      app.border_color_hex, app.app_group, app.display_order
    ]);
    pool.query(insertQuery, [values], (err, result) => {
      if (err) {
        console.error("Error saving applications:", err);
        console.error("SQL Error details:", err.sqlMessage);
        return res.status(500).json({ 
          error: 'Failed to save applications.',
          details: err.sqlMessage || err.message
        });
      }
      console.log(`Successfully saved ${result.affectedRows} applications.`);
      res.status(201).send('Applications saved successfully.');
    });
  });
});

app.post('/api/validate-app-name', (req, res) => {
  const { name, app_group } = req.body;
  if (!name) {
    return res.status(400).json({ error: 'Name is required' });
  }
  
  const nameValidation = validateAppName(name);
  if (!nameValidation.isValid) {
    return res.json(nameValidation);
  }
  
  if (app_group) {
    const groupValidation = validateAppGroup(app_group);
    if (!groupValidation.isValid) {
      return res.json(groupValidation);
    }
  }
  
  res.json({ isValid: true });
});

app.put('/api/settings', (req, res) => {
  const settings = req.body;
  const queries = Object.keys(settings).map(key => {
    return new Promise((resolve, reject) => {
      const query = 'UPDATE settings SET setting_value = ? WHERE setting_key = ?';
      pool.query(query, [settings[key], key], (err, result) => {
        if (err) return reject(err);
        resolve(result);
      });
    });
  });

  Promise.all(queries)
    .then(() => res.send('Settings updated successfully.'))
    .catch(err => {
      console.error("Error updating settings:", err);
      res.status(500).json({ error: 'Failed to update settings.' });
    });
});

app.listen(port, () => {
  console.log(`Server is running on http://${serverIp}:${port}`);
});