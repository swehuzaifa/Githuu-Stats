const axios = require('axios');

module.exports = async (req, res) => {
    // Enable CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    const token = process.env.GITHUB_TOKEN;
    const username = process.env.GITHUB_USERNAME || 'swehuzaifa';

    if (!token || token === 'your_token_here') {
        return res.status(500).json({
            error: 'GitHub token not configured. Set GITHUB_TOKEN in Vercel env variables.',
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
            return res.status(400).json({ error: response.data.errors });
        }

        const user = response.data.data.user;
        const calendar = user.contributionsCollection.contributionCalendar;

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

        res.status(200).json({
            name: user.name,
            avatarUrl: user.avatarUrl,
            bio: user.bio,
            totalContributions: calendar.totalContributions,
            days,
        });
    } catch (error) {
        res.status(500).json({
            error: 'Failed to fetch GitHub data',
            details: error.message,
        });
    }
};
