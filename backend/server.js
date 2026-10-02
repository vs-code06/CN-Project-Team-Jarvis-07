const express = require("express");

const app = express();

const backendName = process.argv[2] || "A";
const port = Number(process.argv[3]) || 3001;

app.get("/", (req, res) => {
    res.json({
        backend: backendName,
        message: "Hello from backend " + backendName
    });
});

app.get("/api/status", (req, res) => {
    res.set("X-Backend", backendName);

    res.json({
        backend: backendName,
        status: "ok"
    });
});

app.get("/api/cached", (req, res) => {
    res.set("X-Backend", backendName);
    res.set("Cache-Control", "max-age=60");

    res.json({
        data: "static content"
    });
});

app.listen(port, "0.0.0.0", () => {
    console.log(`Backend ${backendName} running on port ${port}`);
});
