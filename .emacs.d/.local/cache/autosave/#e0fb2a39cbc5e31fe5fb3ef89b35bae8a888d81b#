import axios from "axios";
import fs from "fs";

const response = await axios.get("https://jsonplaceholder.typicode.com/posts", {
  headers: { "Accept-Encoding": "gzip,deflate,compress" },
});
response.data.forEach((element) => {
  fs.appendFileSync("posts.txt", JSON.stringify(element) + "\n");
});
