const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for Flutter access
app.use(cors());
app.use(express.json());

// Health check
app.get('/', (req, res) => {
    res.json({ status: 'ok', message: 'GitHub Stats Backend is running' });
});

// GitHub Contributions endpoint
app.get('/github-contributions', async (req, res) => {
    const token = process.env.GITHUB_TOKEN;
    const username = process.env.GITHUB_USERNAME || 'swehuzaifa';

    if (!token || token === 'your_token_here') {
        return res.status(500).json({
            error: 'GitHub token not configured. Please set GITHUB_TOKEN in .env',
        });
    }

    const query = `
    query {
      user(login: "${username}") {
        name
        avatarUrl
        bio
        contributionsCollection {
          contributionCalendar {
            totalContributions
            weeks {
              contributionDays {
                date
                contributionCount
                color
              }
            }
          }
        }
      }
    }
  `;

    try {
        const response = await axios.post(
            'https://api.github.com/graphql',
            { query },
            {
                headers: {
                    Authorization: `Bearer ${token}`,
                    'Content-Type': 'application/json',
                    'User-Agent': 'GitHubStats-Backend',
                },
            }
        );

        if (response.data.errors) {
            console.error('GraphQL errors:', response.data.errors);
            return res.status(400).json({ error: response.data.errors });
        }

        const user = response.data.data.user;
        const calendar = user.contributionsCollection.contributionCalendar;

        // Flatten weeks → days for easy Flutter consumption
        const days = [];
        for (const week of calendar.weeks) {
            for (const day of week.contributionDays) {
                days.push({
                    date: day.date,
                    count: day.contributionCount,
                    color: day.color,
                });
            }
        }

        res.json({
            name: user.name,
            avatarUrl: user.avatarUrl,
            bio: user.bio,
            totalContributions: calendar.totalContributions,
            days,
        });
    } catch (error) {
        console.error('GitHub API error:', error.message);
        res.status(500).json({
            error: 'Failed to fetch GitHub data',
            details: error.message,
        });
    }
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`✅ GitHub Stats Backend running on http://localhost:${PORT}`);
    console.log(`📡 Contributions endpoint: http://localhost:${PORT}/github-contributions`);
});
