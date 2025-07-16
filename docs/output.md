Project Structure
==================================================
html/
├── .nojekyll
├── _headers
├── index.html
├── task.html
└── team.html

File Contents
==================================================

<<< html/.nojekyll >>>



<<< html/_headers >>>

/*.json
  Cache-Control: no-cache, no-store, must-revalidate
  Pragma: no-cache
  Expires: 0

/*.html
  Cache-Control: no-cache, no-store, must-revalidate
  Pragma: no-cache
  Expires: 0


<<< html/index.html >>>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap">
    <title>Payroll Calculator Leaderboard</title>
    <style>
        :root {
            --primary: #1976d2;
            --success: #4caf50;
            --warning: #ff9800;
            --error: #f44336;
            --surface: #fff;
            --bg: #f5f5f5;
            --text: #212121;
            --text-light: #757575;
            --border: #e0e0e0;
            --shadow: 0 2px 8px rgba(0,0,0,0.1);
            --radius: 12px;
            --gold: #ffd700;
            --silver: #c0c0c0;
            --bronze: #cd7f32;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Roboto', sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.6;
            padding: 24px;
        }

        .container { max-width: 900px; margin: 0 auto; }

        .header {
            text-align: center;
            margin-bottom: 32px;
        }

        .header h1 {
            font-size: 3rem;
            font-weight: 300;
            color: var(--text);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 16px;
        }

        .header-subtitle {
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }



        .leaderboard {
            background: var(--surface);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .team-row {
            display: flex;
            align-items: center;
            padding: 24px;
            border-bottom: 1px solid var(--border);
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
            position: relative;
        }

        .team-row:hover {
            background: rgba(25, 118, 210, 0.04);
            transform: translateY(-2px);
        }

        .team-row:last-child { border-bottom: none; }

        .rank {
            font-size: 2.5rem;
            font-weight: 300;
            margin-right: 24px;
            min-width: 80px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .rank.first { color: var(--gold); }
        .rank.second { color: var(--silver); }
        .rank.third { color: var(--bronze); }

        .team-info {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .team-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: white;
            font-size: 1.5rem;
            box-shadow: var(--shadow);
        }

        .team-avatar.alpha { background: linear-gradient(135deg, #4caf50, #81c784); }
        .team-avatar.beta { background: linear-gradient(135deg, #2196f3, #64b5f6); }
        .team-avatar.gamma { background: linear-gradient(135deg, #ff9800, #ffb74d); color: #333; }
        .team-avatar.delta { background: linear-gradient(135deg, #f44336, #e57373); }

        .team-details h3 {
            font-size: 1.5rem;
            font-weight: 500;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .team-subtitle {
            color: var(--text-light);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .score-section {
            text-align: right;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
        }

        .score-display {
            font-size: 2.2rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .score-display.high { color: var(--success); }
        .score-display.medium { color: var(--warning); }
        .score-display.low { color: var(--error); }

        .build-status {
            background: rgba(244, 67, 54, 0.1);
            color: var(--error);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            border: 1px solid rgba(244, 67, 54, 0.3);
        }

        .team-link-icon {
            position: absolute;
            right: 24px;
            opacity: 0;
            transition: all 0.2s;
            color: var(--primary);
        }

        .team-row:hover .team-link-icon {
            opacity: 1;
        }

        .loading, .error {
            text-align: center;
            padding: 64px 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 16px;
            background: var(--surface);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .loading .material-icons, .error .material-icons {
            font-size: 64px;
            opacity: 0.5;
        }

        .error { color: var(--error); }

        .last-updated {
            text-align: center;
            color: var(--text-light);
            font-size: 0.9rem;
            margin-top: 24px;
            padding: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        @media (max-width: 768px) {
            body { padding: 16px; }
            .header h1 { font-size: 2.2rem; flex-direction: column; gap: 8px; }
            .team-row { padding: 20px 16px; }
            .rank { font-size: 2rem; min-width: 60px; margin-right: 16px; }
            .team-avatar { width: 56px; height: 56px; font-size: 1.3rem; }
            .team-details h3 { font-size: 1.3rem; }
            .score-display { font-size: 1.8rem; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>
            <span class="material-icons" style="font-size: 3rem; color: var(--gold);">emoji_events</span>
            Leaderboard
        </h1>
        <p class="header-subtitle">
            <span class="material-icons">info</span>
            Click on team name for detailed results
        </p>
    </div>

    <div id="loading" class="loading">
        <span class="material-icons">hourglass_empty</span>
        <div>Loading results...</div>
    </div>

    <div id="error" class="error" style="display: none;">
        <span class="material-icons">error_outline</span>
        <div>Failed to load results</div>
    </div>


    <div id="leaderboard" class="leaderboard" style="display: none;"></div>
    <div class="last-updated" id="lastUpdated"></div>
</div>

<script>
  const getScoreClass = p => p >= 70 ? 'high' : p >= 40 ? 'medium' : 'low';
  const getRankClass = r => ['', 'first', 'second', 'third'][r] || '';
  const getRankIcon = r => r <= 3 ? ['', 'emoji_events', 'military_tech', 'workspace_premium'][r] : null;

  function getTeamScore(data) {
    const failed = data.build_status !== 'success';
    return {
      score: failed ? -1 : data.results.score?.percentage || 0,
      percentage: failed ? 0 : data.results.score?.percentage || 0,
      failed
    };
  }

  function createStats(results) {
    return '';
  }

  function createTeamRow(data, rank) {
    const { team, timestamp } = data;
    const scoreData = getTeamScore(data);
    const rankIcon = getRankIcon(rank);

    let scoreSection;
    if (data.build_status !== 'success') {
      const status = data.build_status === 'compilation_failed' ? 'Compilation Failed' : 'Execution Failed';
      scoreSection = `
            <div class="score-section">
                <div class="build-status">
                    <span class="material-icons">error</span>
                    ${status}
                </div>
            </div>
        `;
    } else {
      scoreSection = `
            <div class="score-section">
                <div class="score-display ${getScoreClass(scoreData.percentage)}">
                    <span class="material-icons">check_circle</span>
                    ${scoreData.percentage}/100
                </div>
                <div style="color: var(--text-light); font-size: 1rem;">${scoreData.percentage}% completed</div>
            </div>
        `;
    }

    return `
        <a href="${team}.html" class="team-row">
            <div class="rank ${getRankClass(rank)}">
                ${rankIcon ? `<span class="material-icons" style="font-size: 1.8rem;">${rankIcon}</span>` : `#${rank}`}
            </div>
            <div class="team-info">
                <div class="team-avatar ${team}">
                    ${team.charAt(0).toUpperCase()}
                </div>
                <div class="team-details">
                    <h3>Team ${team}</h3>
                    <div class="team-subtitle">
                        <span class="material-icons" style="font-size: 16px;">schedule</span>
                        ${new Date(timestamp).toLocaleString()}
                    </div>
                </div>
            </div>
            ${scoreSection}
            <span class="material-icons team-link-icon">open_in_new</span>
        </a>
    `;
  }

  async function loadResults() {
    try {
      const teams = ['alpha', 'beta', 'gamma', 'delta'];
      const results = [];
      const timestamp = Date.now();

      for (const team of teams) {
        try {
          const response = await fetch(`${team}.json?v=${timestamp}`);
          if (response.ok) results.push(await response.json());
        } catch (e) {
          console.warn(`Failed to load ${team}:`, e);
        }
      }

      if (results.length === 0) throw new Error('No results found');

      // Sort by score
      results.sort((a, b) => {
        const aScore = getTeamScore(a);
        const bScore = getTeamScore(b);

        if (aScore.failed && !bScore.failed) return 1;
        if (!aScore.failed && bScore.failed) return -1;
        if (aScore.failed && bScore.failed) return 0;

        return bScore.percentage - aScore.percentage;
      });

      // Update UI
      document.getElementById('leaderboard').innerHTML = results.map((team, i) => createTeamRow(team, i + 1)).join('');

      const latestTime = Math.max(...results.map(r => new Date(r.timestamp).getTime()));
      document.getElementById('lastUpdated').innerHTML = `
            <span class="material-icons">update</span>
            Last updated: ${new Date(latestTime).toLocaleString()}
        `;

      document.getElementById('loading').style.display = 'none';
      document.getElementById('leaderboard').style.display = 'block';

    } catch (error) {
      console.error('Error:', error);
      document.getElementById('loading').style.display = 'none';
      document.getElementById('error').style.display = 'flex';
    }
  }

  loadResults();
  setInterval(loadResults, 30000);
</script>
</body>
</html>

<<< html/task.html >>>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title id="pageTitle">Task Details - Payroll Calculator</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f4f5f7;
            padding: 20px;
            line-height: 1.5;
            color: #172b4d;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #0052cc;
            color: white;
            padding: 8px 16px;
            border-radius: 3px;
            text-decoration: none;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.2s;
        }

        .back-btn:hover {
            background: #0065ff;
        }

        .task-card {
            background: white;
            border-radius: 3px;
            box-shadow: 0 1px 2px rgba(9, 30, 66, 0.25);
            margin-bottom: 16px;
            border: 1px solid #dfe1e6;
        }

        .task-header {
            padding: 32px 32px 24px 32px;
            border-bottom: 1px solid #dfe1e6;
        }

        .task-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .task-key {
            background: #dfe1e6;
            color: #5e6c84;
            padding: 6px 10px;
            border-radius: 3px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .task-type {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #5e6c84;
            font-weight: 500;
        }

        .type-icon {
            width: 18px;
            height: 18px;
            border-radius: 3px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            color: white;
            font-weight: 700;
        }

        .type-icon.requirement { background: #0052cc; }
        .type-icon.bug { background: #de350b; }
        .type-icon.task { background: #0052cc; }
        .type-icon.story { background: #00875a; }

        .priority-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
        }

        .priority-icon {
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .priority-critical .priority-icon { color: #de350b; }
        .priority-urgent .priority-icon { color: #ff8b00; }
        .priority-normal .priority-icon { color: #0052cc; }

        .task-title {
            font-size: 28px;
            font-weight: 500;
            color: #172b4d;
            margin-bottom: 12px;
            line-height: 1.2;
        }

        .task-summary {
            color: #5e6c84;
            font-size: 16px;
            font-weight: 400;
        }

        .task-content {
            padding: 32px;
        }

        .section {
            margin-bottom: 40px;
        }

        .section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #172b4d;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .content-block {
            background: #f4f5f7;
            border: 1px solid #dfe1e6;
            border-radius: 3px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .content-block.email {
            border-left: 4px solid #0052cc;
            background: #deebff;
        }

        .content-block.ticket {
            border-left: 4px solid #ff8b00;
            background: #fff4e6;
        }

        .content-block.support {
            border-left: 4px solid #de350b;
            background: #ffebe6;
        }

        .content-block.requirement {
            border-left: 4px solid #0052cc;
            background: #e6fcff;
        }

        .block-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            color: #172b4d;
            margin-bottom: 16px;
            font-size: 16px;
        }

        .block-subject {
            font-size: 18px;
            font-weight: 600;
            color: #172b4d;
            margin-bottom: 12px;
        }

        .block-meta {
            font-size: 13px;
            color: #5e6c84;
            margin-bottom: 16px;
        }

        .block-content {
            color: #172b4d;
            white-space: pre-line;
            line-height: 1.7;
            font-size: 15px;
        }

        .jira-table {
            width: 100%;
            border-collapse: collapse;
            margin: 16px 0;
            background: white;
            border: 1px solid #dfe1e6;
            border-radius: 3px;
            overflow: hidden;
        }

        .jira-table th {
            background: #f4f5f7;
            color: #5e6c84;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dfe1e6;
        }

        .jira-table td {
            padding: 12px;
            border-bottom: 1px solid #dfe1e6;
            color: #172b4d;
        }

        .jira-table tr:last-child td {
            border-bottom: none;
        }

        .scope-list {
            background: white;
            border: 1px solid #dfe1e6;
            border-radius: 3px;
            padding: 16px;
        }

        .scope-list ul {
            margin-left: 20px;
        }

        .scope-list li {
            margin-bottom: 8px;
            color: #172b4d;
        }

        .loading {
            text-align: center;
            padding: 60px;
            color: #5e6c84;
            font-size: 16px;
        }

        .error {
            background: #ffebe6;
            color: #de350b;
            padding: 24px;
            border-radius: 3px;
            text-align: center;
            margin: 20px 0;
            border: 1px solid #ffbdad;
        }

        .description-text {
            color: #172b4d;
            line-height: 1.6;
            white-space: pre-line;
        }

        .email-header {
            background: #f4f5f7;
            padding: 16px;
            border-radius: 3px;
            margin-bottom: 16px;
            border: 1px solid #dfe1e6;
        }

        .email-field {
            display: flex;
            margin-bottom: 6px;
        }

        .email-field:last-child {
            margin-bottom: 0;
        }

        .email-field-label {
            font-weight: 700;
            color: #5e6c84;
            width: 100px;
            flex-shrink: 0;
            font-size: 14px;
        }

        .email-field-value {
            color: #172b4d;
            font-size: 14px;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .task-header, .task-content {
                padding: 16px;
            }

            .task-title {
                font-size: 20px;
            }

            .task-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
<div class="container">

    <div id="loading" class="loading">
        Loading task details...
    </div>

    <div id="error" class="error" style="display: none;">
        Task not found
    </div>

    <div id="taskContent" style="display: none;">
        <!-- Task content will be populated here -->
    </div>
</div>

<script>
  function getTaskId() {
    const path = window.location.pathname;
    const filename = path.split('/').pop();
    return filename.replace('task-', '').replace('.html', '');
  }

  function formatDescription(text) {
    return text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
  }

  function getTypeIcon(type) {
    const icons = {
      'requirement': 'R',
      'email': 'E',
      'ticket': 'T',
      'support_note': 'S'
    };
    return icons[type] || 'T';
  }

  function getTypeLabel(type) {
    const labels = {
      'requirement': 'Requirement',
      'email': 'Bug',
      'ticket': 'Story',
      'support_note': 'Bug'
    };
    return labels[type] || 'Task';
  }

  function getPriorityIcon(priority) {
    if (priority === 'critical') return '🔴';
    if (priority === 'urgent') return '🟠';
    return '🔵';
  }

  function renderTaskContent(task, taskId) {
    const typeClass = task.type || 'task';
    const typeIcon = getTypeIcon(task.type);
    const typeLabel = getTypeLabel(task.type);
    const priorityIcon = getPriorityIcon(task.priority);

    let contentHtml = `
      <div class="task-card">
        <div class="task-header">
          <div class="task-meta">
            <div class="task-key">TASK-${taskId.padStart(2, '0')}</div>
            <div class="task-type">
              <div class="type-icon ${typeClass}">${typeIcon}</div>
              ${typeLabel}
            </div>
            <div class="priority-badge priority-${task.priority}">
              <span class="priority-icon">${priorityIcon}</span>
              ${task.priority.charAt(0).toUpperCase() + task.priority.slice(1)}
            </div>
          </div>
          <h1 class="task-title">${task.title}</h1>
          <div class="task-summary">Payroll System Issue</div>
        </div>

        <div class="task-content">
    `;

    // Description section
    contentHtml += `
      <div class="section">
        <div class="section-title">📝 Description</div>
    `;

    if (task.type === 'email') {
      contentHtml += `
        <div class="content-block email">
          <div class="block-header">📧 Email Report</div>
          ${task.subject ? `
            <div class="email-header">
              <div class="email-field">
                <div class="email-field-label">Subject:</div>
                <div class="email-field-value">${task.subject}</div>
              </div>
              ${task.sender ? `
                <div class="email-field">
                  <div class="email-field-label">From:</div>
                  <div class="email-field-value">${task.sender}</div>
                </div>
              ` : ''}
            </div>
          ` : ''}
          <div class="block-content">${formatDescription(task.description)}</div>
        </div>
      `;
    } else if (task.type === 'ticket') {
      contentHtml += `
        <div class="content-block ticket">
          <div class="block-header">🎫 ${task.ticket || 'Support Ticket'}</div>
          ${task.subject ? `<div class="block-subject">${task.subject}</div>` : ''}
          <div class="block-content">${formatDescription(task.description)}</div>
        </div>
      `;
    } else if (task.type === 'support_note') {
      contentHtml += `
        <div class="content-block support">
          <div class="block-header">🆘 Critical Issue Report</div>
          <div class="email-header">
            <div class="email-field">
              <div class="email-field-label">Employee:</div>
              <div class="email-field-value">${task.employee}</div>
            </div>
            <div class="email-field">
              <div class="email-field-label">Department:</div>
              <div class="email-field-value">${task.department}</div>
            </div>
            <div class="email-field">
              <div class="email-field-label">Issue Type:</div>
              <div class="email-field-value">${task.issue}</div>
            </div>
          </div>
          <div class="block-content">${formatDescription(task.description)}</div>
        </div>
      `;
    } else if (task.type === 'requirement') {
      contentHtml += `
        <div class="content-block requirement">
          <div class="block-header">⚙️ System Requirement</div>
          <div class="block-content">${formatDescription(task.description)}</div>
        </div>
      `;
    } else {
      contentHtml += `
        <div class="description-text">${formatDescription(task.description)}</div>
      `;
    }

    contentHtml += `</div>`;

    // Additional sections
    if (task.details && task.details.taxClasses) {
      contentHtml += `
        <div class="section">
          <div class="section-title">📊 Tax Class Configuration</div>
          <table class="jira-table">
            <thead>
              <tr>
                <th>Tax Class</th>
                <th>Description</th>
                <th>Approx. Rate</th>
              </tr>
            </thead>
            <tbody>
              ${task.details.taxClasses.map(tc =>
        `<tr>
                  <td><strong>${tc.class}</strong></td>
                  <td>${tc.description}</td>
                  <td>${tc.rate}</td>
                </tr>`
      ).join('')}
            </tbody>
          </table>
        </div>
      `;
    }

    if (task.details && task.details.scope) {
      contentHtml += `
        <div class="section">
          <div class="section-title">🎯 Acceptance Criteria</div>
          <div class="scope-list">
            <ul>
              ${task.details.scope.map(item => `<li>${item}</li>`).join('')}
            </ul>
          </div>
        </div>
      `;
    }

    if (task.emails) {
      contentHtml += `
        <div class="section">
          <div class="section-title">📧 Related Reports</div>
      `;
      task.emails.forEach((email, index) => {
        contentHtml += `
          <div class="content-block email">
            <div class="block-header">📧 Report ${index + 1}</div>
            <div class="email-header">
              <div class="email-field">
                <div class="email-field-label">From:</div>
                <div class="email-field-value">${email.sender}</div>
              </div>
              <div class="email-field">
                <div class="email-field-label">Subject:</div>
                <div class="email-field-value">${email.subject}</div>
              </div>
            </div>
            <div class="block-content">${formatDescription(email.content)}</div>
          </div>
        `;
      });
      contentHtml += `</div>`;
    }

    contentHtml += `
        </div>
      </div>
    `;

    return contentHtml;
  }

  async function loadTaskDetails() {
    try {
      const taskId = getTaskId();

      const timestamp = Date.now();
      const response = await fetch(`tasks.json?v=${timestamp}`);

      if (!response.ok) {
        throw new Error('Failed to load tasks data');
      }

      const tasksData = await response.json();
      const task = tasksData[taskId];

      if (!task) {
        throw new Error('Task not found');
      }

      document.getElementById('pageTitle').textContent = `TASK-${taskId.padStart(2, '0')} - ${task.title}`;

      const taskContent = document.getElementById('taskContent');
      taskContent.innerHTML = renderTaskContent(task, taskId);

      document.getElementById('loading').style.display = 'none';
      document.getElementById('taskContent').style.display = 'block';

    } catch (error) {
      console.error('Error loading task details:', error);
      document.getElementById('loading').style.display = 'none';
      document.getElementById('error').style.display = 'block';
    }
  }

  loadTaskDetails();
</script>
</body>
</html>

<<< html/team.html >>>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap">
    <title id="pageTitle">Team Details</title>
    <style>
        :root {
            --primary: #1976d2;
            --success: #4caf50;
            --warning: #ff9800;
            --error: #f44336;
            --surface: #fff;
            --bg: #f5f5f5;
            --text: #212121;
            --text-light: #757575;
            --border: #e0e0e0;
            --shadow: 0 2px 8px rgba(0,0,0,0.1);
            --radius: 8px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Roboto', sans-serif;
            background: var(--bg);
            color: var(--text);
            height: 100vh;
            overflow: hidden;
        }

        .grid {
            display: grid;
            grid-template-columns: 350px 1fr;
            height: 100vh;
        }

        .sidebar {
            background: var(--surface);
            box-shadow: var(--shadow);
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            overflow-y: auto;
        }

        .tasks {
            padding: 24px;
            overflow-y: auto;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            padding: 8px 0;
            transition: transform 0.2s;
        }

        .back-btn:hover { transform: translateX(-4px); }

        .team-card {
            text-align: center;
            padding: 24px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: var(--radius);
            position: relative;
            overflow: hidden;
        }

        .team-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--team-color);
        }

        .team-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: var(--team-color);
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
        }

        .team-title {
            font-size: 1.5rem;
            font-weight: 300;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .team-subtitle {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 16px;
        }

        .score {
            font-size: 2.5rem;
            font-weight: 300;
            color: var(--warning);
        }

        .status-section h3, .commit-section h3 {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1rem;
            font-weight: 500;
            margin-bottom: 16px;
        }

        .status-grid {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .status-chip {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px;
            border-radius: var(--radius);
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
            position: relative;
            cursor: help;
        }

        .status-chip:hover {
            transform: translateX(4px);
        }

        .status-chip[data-tooltip]:hover::after {
            content: attr(data-tooltip);
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.9);
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 0.75rem;
            z-index: 1000;
            margin-top: 8px;
            max-width: 300px;
            white-space: normal;
            text-align: center;
            line-height: 1.3;
        }

        .status-chip[data-tooltip]:hover::before {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            border: 4px solid transparent;
            border-bottom-color: rgba(0, 0, 0, 0.9);
            margin-top: 4px;
        }

        .status-label {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-icon {
            font-size: 20px;
        }

        .status-success {
            background: rgba(76, 175, 80, 0.1);
            color: var(--success);
            border: 1px solid rgba(76, 175, 80, 0.3);
        }

        .status-error {
            background: rgba(244, 67, 54, 0.1);
            color: var(--error);
            border: 1px solid rgba(244, 67, 54, 0.3);
        }

        .status-warning {
            background: rgba(255, 152, 0, 0.1);
            color: var(--warning);
            border: 1px solid rgba(255, 152, 0, 0.3);
        }

        .commit-info {
            background: #f8f9fa;
            padding: 12px;
            border-radius: var(--radius);
            font-size: 0.85rem;
            line-height: 1.4;
        }

        .commit-info div {
            margin-bottom: 4px;
            word-break: break-all;
        }

        .commit-info strong {
            color: var(--text);
            min-width: 60px;
            display: inline-block;
        }

        .tasks-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }

        .tasks-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1.25rem;
            font-weight: 500;
        }

        .tasks-hint {
            font-size: 0.875rem;
            color: var(--text-light);
        }

        .task-item {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            margin-bottom: 6px;
            background: var(--surface);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            cursor: pointer;
            transition: all 0.2s;
        }

        .task-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .task-item.ignored {
            opacity: 0.5;
            background: #f5f5f5;
        }

        .task-item.ignored:hover {
            opacity: 0.7;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .task-icon {
            margin-right: 12px;
            color: var(--primary);
            font-size: 20px;
            flex-shrink: 0;
        }

        .task-number {
            min-width: 40px;
            height: 32px;
            border-radius: 6px;
            background: var(--primary);
            color: white;
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            flex-shrink: 0;
        }

        .task-weight {
            background: rgba(117, 117, 117, 0.1);
            color: var(--text-light);
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 8px;
            flex-shrink: 0;
        }

        .task-content {
            flex: 1;
            min-width: 0;
        }

        .task-title {
            font-weight: 500;
            margin-bottom: 2px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 0.9rem;
        }

        .task-meta {
            font-size: 0.75rem;
            color: var(--text-light);
        }

        .progress-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.75rem;
            margin-left: 12px;
            flex-shrink: 0;
        }

        .progress-100 { background: rgba(76, 175, 80, 0.15); color: var(--success); }
        .progress-0 { background: rgba(158, 158, 158, 0.15); color: #757575; }
        .progress-compatibility { background: rgba(255, 152, 0, 0.15); color: var(--warning); }

        .loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            gap: 16px;
        }

        .last-updated {
            position: fixed;
            bottom: 16px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.875rem;
            color: var(--text-light);
            background: var(--surface);
            padding: 8px 16px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        /* Team colors */
        .alpha { --team-color: #4caf50; }
        .beta { --team-color: #2196f3; }
        .gamma { --team-color: #ff9800; }
        .delta { --team-color: #f44336; }

        @media (max-width: 968px) {
            .grid { grid-template-columns: 1fr; }
            .sidebar { order: 2; height: auto; max-height: 50vh; }
            .tasks { order: 1; }
        }
    </style>
</head>
<body>
<div id="loading" class="loading">
    <span class="material-icons">hourglass_empty</span>
    <div>Loading...</div>
</div>

<div id="error" class="loading" style="display: none;">
    <span class="material-icons">error_outline</span>
    <div>Failed to load</div>
</div>

<div id="app" style="display: none;"></div>
<div id="lastUpdated" class="last-updated"></div>

<script>
  let tasksData = {};

  const icons = { email: 'mail', ticket: 'confirmation_number', requirement: 'assignment', support_note: 'note' };

  const getTaskIcon = id => icons[tasksData[id]?.type] || 'description';
  const getTaskTitle = id => {
    const task = tasksData[id];
    return task ? task.title + (task.ticket ? ` [${task.ticket}]` : '') : `Task ${id}`;
  };
  const getTaskMeta = id => {
    const task = tasksData[id];
    if (!task) return '';
    const parts = [];
    if (task.priority) parts.push(`Priority: ${task.priority}`);
    if (task.type) parts.push(`Type: ${task.type}`);
    return parts.join(' • ');
  };

  async function loadTasksData() {
    try {
      const response = await fetch(`tasks.json?v=${Date.now()}`);
      if (response.ok) tasksData = await response.json();
    } catch (e) { console.error('Error loading tasks:', e); }
  }

  function createApp(data) {
    const { team, commit, results } = data;
    const tasks = results.tasks || [];
    const completed = tasks.filter(t => t.progress === 100).length;
    const percentage = results.score?.percentage || 0;

    // Отладка - выводим данные
    console.log('All data:', data);
    console.log('Tasks array:', tasks);

    document.title = `Team ${team.toUpperCase()}`;

    return `
        <div class="grid">
            <div class="sidebar">
                <a href="index.html" class="back-btn">
                    <span class="material-icons">arrow_back</span>
                    Back to Leaderboard
                </a>

                <div class="team-card ${team}">
                    <div class="team-avatar">${team.charAt(0).toUpperCase()}</div>
                    <h1 class="team-title">Team ${team}</h1>
                    <div class="team-subtitle">Payroll Calculator Challenge</div>
                    <div class="score">${percentage}/100</div>
                </div>

                <div class="status-section">
                    <h3><span class="material-icons">build</span>Build Status</h3>
                    <div class="status-grid">
                        <div class="status-chip ${results.compiled ? 'status-success' : 'status-error'}" ${!results.compiled ? 'data-tooltip="Project cannot be compiled due to code errors"' : ''}>
                            <div class="status-label">
                                <span class="material-icons status-icon">${results.compiled ? 'check_circle' : 'error'}</span>
                                <span>Compilation</span>
                            </div>
                            <span class="material-icons">${results.compiled ? 'done' : 'close'}</span>
                        </div>
                        <div class="status-chip ${results.executed ? 'status-success' : 'status-error'}" ${!results.executed ? 'data-tooltip="Runtime error occurred when starting the project"' : ''}>
                            <div class="status-label">
                                <span class="material-icons status-icon">${results.executed ? 'play_circle' : 'error'}</span>
                                <span>Execution</span>
                            </div>
                            <span class="material-icons">${results.executed ? 'done' : 'close'}</span>
                        </div>
                        <div class="status-chip ${results.compatibility ? 'status-success' : 'status-warning'}" ${!results.compatibility ? 'data-tooltip="Some tests cannot be executed due to external test compatibility issues"' : ''}>
                            <div class="status-label">
                                <span class="material-icons status-icon">${results.compatibility ? 'verified' : 'warning'}</span>
                                <span>Compatibility</span>
                            </div>
                            <span class="material-icons">${results.compatibility ? 'done' : 'priority_high'}</span>
                        </div>
                    </div>
                </div>

                <div class="commit-section">
                    <h3><span class="material-icons">commit</span>Commit Info</h3>
                    <div class="commit-info">
                        <div><strong>Hash:</strong> ${commit.hash.substring(0, 12)}</div>
                        <div><strong>Author:</strong> ${commit.author}</div>
                        <div><strong>Message:</strong> ${commit.message}</div>
                        <div><strong>Date:</strong> ${new Date(commit.date).toLocaleString()}</div>
                    </div>
                </div>
            </div>

            <div class="tasks">
                <div class="tasks-header">
                    <h2 class="tasks-title">
                        <span class="material-icons">assignment</span>
                        Tasks (${completed}/${tasks.length})
                    </h2>
                    <div class="tasks-hint">Click for details</div>
                </div>

                ${tasks.map(task => {
      let progressClass = 'progress-0';
      let progressText = `${task.progress}%`;
      let taskItemClass = '';

      if (task.progress === 100) {
        progressClass = 'progress-100';
      } else if (task.type === 'not_executed' && !results.compatibility) {
        progressClass = 'progress-compatibility';
        progressText = '⚠';
        taskItemClass = 'ignored';
      } else if (task.type === 'not_executed') {
        taskItemClass = 'ignored';
      }

      return `
                    <div class="task-item ${taskItemClass}" onclick="openTaskDetails('${task.task_id}')">
                        <span class="material-icons task-icon">${getTaskIcon(task.task_id)}</span>
                        <div class="task-content">
                            <div class="task-title">${getTaskTitle(task.task_id)}</div>
                            <div class="task-meta">${getTaskMeta(task.task_id)} ${task.type === 'not_executed' ? '• Not executed' : ''}</div>
                        </div>
                        <div class="progress-circle ${progressClass}">
                            ${progressText}
                        </div>
                    </div>
                `;
    }).join('')}
            </div>
        </div>
    `;
  }

  async function load() {
    try {
      await loadTasksData();
      const team = window.location.pathname.split('/').pop().replace('.html', '');

      if (!['alpha', 'beta', 'gamma', 'delta'].includes(team)) throw new Error('Invalid team');

      const response = await fetch(`${team}.json?v=${Date.now()}`);
      if (!response.ok) throw new Error('Failed to fetch data');

      const data = await response.json();

      document.getElementById('app').innerHTML = createApp(data);
      document.getElementById('lastUpdated').textContent = `Last updated: ${new Date(data.timestamp).toLocaleString()}`;

      document.getElementById('loading').style.display = 'none';
      document.getElementById('app').style.display = 'block';

    } catch (e) {
      console.error('Error:', e);
      document.getElementById('loading').style.display = 'none';
      document.getElementById('error').style.display = 'flex';
    }
  }

  function openTaskDetails(taskId) { window.open(`task-${taskId}.html`, '_blank'); }

  load();
  setInterval(load, 30000);
</script>
</body>
</html>

