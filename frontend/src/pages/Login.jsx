import React, { useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Player } from "@lottiefiles/react-lottie-player";
import { TbLock, TbMail } from "react-icons/tb";
import Button from "../components/Button";
import Dropdown from "../components/Dropdown/Dropdown";

import APIService from "../api/Service";
import TextInput from "../components/TextInput";
import { equalsIgnoreCase } from "../utils";

export default function Login() {
  const navigate = useNavigate();
  const [userCredentials, setUserCredentials] = useState({
    email: "",
    password: "",
  });

  const playerRef = useRef(null);
  return (
    <div className="login-page">
      <div className="login-container">
        <div className="image">
          <Player
            onEvent={(event) => {
              if (event === "loop") playerRef?.current?.setSeeker(43, true);
            }}
            src="https://assets1.lottiefiles.com/packages/lf20_jcikwtux.json"
            loop
            autoplay
            ref={playerRef}
          />
        </div>
        <div className="login-wrapper">
          <div className="title">Welcome back!</div>
          <TextInput
            icon={<TbMail />}
            placeholder="you@example.com"
            value={userCredentials.email}
            onChange={(e) =>
              setUserCredentials((old) => ({ ...old, email: e }))
            }
          />
          <TextInput
            icon={<TbLock />}
            type="password"
            placeholder="Your Password"
            value={userCredentials.password}
            onChange={(e) =>
              setUserCredentials((old) => ({ ...old, password: e }))
            }
          />
          <div className="forgot-password">Forgot Password?</div>
          <div
            className="login-button"
            onClick={async () => {
              await APIService.PostData(
                {
                  email: userCredentials.email,
                  password: userCredentials.password,
                },
                "/login"
              ).then((response) => {
                console.log(response);
                if (equalsIgnoreCase(response.status, "login failure"))
                  alert("Invalid Credentials, please try again!");
                else if (equalsIgnoreCase(response.status, "login success")) {
                  navigate("/" + response.utype.toLowerCase());
                }
              });
            }}
          >
            Login
          </div>
        </div>
      </div>
    </div>
  );
}
