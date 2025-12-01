# 🛡️ Service Health Monitor 

A clean, minimal, reusable **DevSecOps-style Service Health Monitoring System** that checks service health, sends alerts, and auto-fixes issues using Docker. Designed exactly according to your architecture — simple, human, and production-friendly.

---

## 🚀 Features

* **HTTP Health Checks** for any service URL.
* **Critical Email Alerts** using Gmail SMTP.
* **Auto-Fix Mechanism:** Automatically restarts a Docker container.
* **Daily/Periodic Reports** via cron.
* **Config-Driven Design** using `config.yaml`.
* **Modular Code:** Separate scripts for monitor, notifier, and auto-fix logic.
* **Developer-Friendly:** Easy to extend and reuse.

---

## 📁 Project Structure

```
project/
│
├── config/
│   └── config.yaml
│
├── scripts/
│   ├── check_health.py
│   ├── auto_fix.py
│   └── notify.py
│
├── requirements.txt
└── README.md
```

---

## ⚙️ Installation

### 1️⃣ Clone the Repository

```
git clone <your-repo-url>
cd project
```

### 2️⃣ Install Dependencies

```
pip install -r requirements.txt
```

### 3️⃣ Configure Monitoring

Edit `config/config.yaml`:

```
monitor_targets:
  - name: nginx-service
    url: "http://<your-server-ip>:80"
    type: "docker"

email:
  sender: "your@gmail.com"
  password: "your-app-password"
  receiver: "your@gmail.com"

auto_fix:
  docker_container_name: "nginx-container"
```

Replace all placeholder values.

---

## ▶️ Run Monitoring

Run a manual health check:

```
python3 scripts/check_health.py
```

What happens:

* Service is checked
* If DOWN → email sent + auto-fix script runs
* If UP → logged and added to report

---

## ⏱️ Cron Automation

Open cron:

```
crontab -e
```

Add this entry to run monitoring every 5 minutes:

```
*/5 * * * * /usr/bin/python3 /path-to-project/scripts/check_health.py
```

---

##  Security Best Practices

* Use **Gmail App Password**, not your real password.
* Do NOT commit secrets to GitHub.
* Restrict Docker access.
* Keep configs outside the repo if using production servers.

---

## 👤 Author

**Saeedullah Shaikh**

---

## 📜 License

Licensed under the **MIT License**.

---




