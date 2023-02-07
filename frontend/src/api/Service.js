// let url = "http://192.168.82.77:2002/";
let url = "http://127.0.0.1:2002/";

export default class APIService {
  static async PostData(body, route) {
    try {
      const response = await fetch(url.concat(route), {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
        body: JSON.stringify(body),
      });
      return await response.json();
    } catch (error) {
      return console.log(error);
    }
  }
}
