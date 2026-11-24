const express = require('express');
const cors = require('cors');
const prisma = require('./prisma');
const app = express();
const PORT = process.env.PORT || 5001;


app.use(cors());
app.use(express.json());

app.get('/api/health', async (req, res) => {
  try {
    const organizationsCount = await prisma.organization.count();
    
    res.status(200).json({
      status: 'success',
      message: 'Server is running and Database is connected successfully!',
      data: { organizationsCount }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Database connection failed',
      error: error.message
    });
  }
});

app.post('/api/organizations', async (req, res) => {
  try {
    const { name } = req.body;

    
    if (!name) {
      return res.status(400).json({ status: 'error', message: 'Organization name is required' });
    }

    
    const newOrganization = await prisma.organization.create({
      data: { name }
    });

    
    res.status(201).json({
      status: 'success',
      message: 'Organization created successfully!',
      data: newOrganization
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to create organization',
      error: error.message
    });
  }
});
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT} 🚀`);
});