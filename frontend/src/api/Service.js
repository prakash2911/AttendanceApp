// let url = "http://192.168.82.77:2002/";
let url = "https://192.168.1.9:2002/";
// let url = "http://192.168.118.6:2002/";
// let url = "http://192.168.69.249:2002/";

let header = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
  // Authorization: sessionStorage,
  // Cookie: sessionStorage.getItem("cookie"),
  credentials: "include",
};

export default class APIService {
  static async PostData(body, route) {
    try {
      Response = await fetch(url.concat(route), {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          // Authorization: sessionStorage,
          Cookie: JSON.parse(sessionStorage.getItem("ck")),
        },
        body: JSON.stringify(body),
      }).then(async (res) => {
        console.log(...res.headers);
        return res;
      });
      return await Response.json();
    } catch (error) {
      return console.log(error);
    }
  }
}

// export default class APIService {
//   static async PostData(body, route) {
//     if (
//       sessionStorage.getItem("ck") !== "undefined" &&
//       JSON.parse(sessionStorage.getItem("ck")) != null
//     ) {
//       let ck = JSON.parse(sessionStorage.getItem("ck"));
//       // header[Cookie] = ck;
//     }
//     try {
//       // console.log(sessionStorage.getItem("cookie"));
//       const response = await fetch(url.concat(route), {
//         method: "POST",
//         headers: header,
//         body: JSON.stringify(body),
//       });
//       sessionStorage.setItem(
//         "ck",
//         JSON.stringify(response.headers["set-cookie"])
//       );
//       console.log(response.headers());
//       return await response.json();
//     } catch (error) {
//       return console.log(error);
//     }
//   }
// }
