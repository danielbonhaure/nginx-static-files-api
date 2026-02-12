# Nginx Static Publisher & API

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=flat&logo=nginx&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)

A specialized Nginx configuration designed to serve static assets while providing a dual-access layer: a human-readable file browser and a machine-readable JSON API.

---

## 🚀 Overview

This repository provides a lightweight solution for sharing files. It eliminates the need for a separate backend by leveraging Nginx to handle both file serving and metadata delivery.

* **Web View:** Access the root path `/` to browse files via the standard Nginx auto-index.
* **API Access:** Query the `/api` endpoint to receive the file list in a structured format for your scripts or frontend.

## ✨ Key Features

* **Automated Indexing:** No manual HTML updates needed; just drop files in the folder.
* **Dual-Purpose:** Serves as both a CDN and a metadata provider.
* **Low Overhead:** Pure Nginx implementation—no Python/Node.js required for the basic list.
* **Customizable:** Easily extendable for specific MIME types or security headers.

## 🛠 Tech Stack

* **Engine:** Nginx (Stable)
* **Deployment:** Docker
* **Format:** HTML (Browsing) & JSON (API)


## Usage

### 1. Build the Image
```bash
docker build --tag custom-nginx:latest .
```

### 2. Run the Container

Mount your local data directories to the internal /usr/share/nginx/static/ path. You can mount multiple folders to create a structured directory tree.

```bash
docker run --name static-files-api \
--mount type=bind,src=/data/static-data-1,dst=/usr/share/nginx/static/folfer-1,ro \
--mount type=bind,src=/data/static-data-2,dst=/usr/share/nginx/static/folder-2,ro \
--publish 8080:80 \
--restart unless-stopped \
--detach custom-nginx:latest
```

### 📂 Path Mapping Reference

| Host Path | Container Path (Internal) | Web/API URL |
| :--- | :--- | :--- |
| `/data/static-data-1` | `/usr/share/nginx/static/folder-1` | `http://localhost:8080/folder-1` |
| `/data/static-data-2` | `/usr/share/nginx/static/folder-2` | `http://localhost:8080/folder-2` |


## 📡 API Reference

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/` | `GET` | Navigable HTML directory listing |
| `/api` | `GET` | Returns file list metadata (JSON) |