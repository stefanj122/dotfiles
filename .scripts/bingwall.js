import axios from "axios";
import fs from "fs";
import path from "path";
import { exec } from "child_process";

//exec("feh --bg-fill /home/stefanj/Pictures/bingwall.png");

async function bingwall() {
  const save = path.resolve("/home/stefanj/", "Pictures", "bingwall.jpg");
  const url2 =
    "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US";

  try {
    const imageUrl = await axios.get(url2);
    const url = "https://bing.com" + imageUrl.data.images[0].url;

    const response = await axios({
      url,
      method: "GET",
      responseType: "stream",
    });

    response.data.pipe(fs.createWriteStream(save));
    console.log("Image saved successfully");
    exec("feh --bg-fill /home/stefanj/Pictures/bingwall.jpg");
  } catch (e) {
    console.log(e.message);
  }
}
bingwall();
exec("pgrep -fc 'bingwall.js'", (err, stdout, stderr) => {
  if (Number(stdout) <= 1) {
    setInterval(() => bingwall(), 1000 * 60 * 60);
  }
});
