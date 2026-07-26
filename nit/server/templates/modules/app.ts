import FalconFrame from "@wxn0brp/falcon-frame";

export const app = new FalconFrame();
app.setOrigin("*");
app.get("/", (req, res) => res.end("Hello!"));
