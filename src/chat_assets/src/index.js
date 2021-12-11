import { idlFactory } from "../../declarations/chat/chat.did.js";
import {AuthClient} from "@dfinity/auth-client";
import { Actor, HttpAgent } from "@dfinity/agent";
import {Principal} from "@dfinity/principal";
var authActor;
document.getElementById("loginBtn").addEventListener("click", async () => {
  const authClient = await AuthClient.create();
  await authClient.login({
    onSuccess: async()=>{
      handleAuthenticated(authClient);
    },
    identityProvider: "http://rwlgt-iiaaa-aaaaa-aaaaa-cai.localhost:8000/#/authorize",
  });
 });

document.getElementById("addUserBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const adduser = await authActor.addUser(name,"","");
  console.log(adduser);
  const prin = await authActor.getShowUserProfileByUserName(name);
  alert("注册成功");
  document.getElementById("addUserBtn").remove();
  document.getElementById("name").remove();
 });

 async function handleAuthenticated(authClient){
   let identityt = await authClient.getIdentity();
   var principal_id = identityt.getPrincipal().toText();    //获取用户的Principal
   console.log(principal_id);
   
   const agent = new HttpAgent({
    identity: identityt,
    host: "http://localhost:8000",
  });
  console.log(agent);
  await agent.fetchRootKey();
  authActor = Actor.createActor(idlFactory, {
    agent,
    canisterId: "r7inp-6aaaa-aaaaa-aaabq-cai",
  });
  let isuserexist = await authActor.isUserExist();
  if(isuserexist){
    document.getElementById("addUserBtn").remove();
    document.getElementById("name").remove();
  };
 }

 document.getElementById("startChat").addEventListener("click", async () => { 
   let user2 = document.getElementById("toName").value;
   let user2_principal = await authActor.getPrincipalByUserName(user2);
   const messageHistory = await authActor.getPreviousMessage(user2_principal);
   var ul=document.getElementById("messageWindow");
   ul.innerHTML="";
   for(var i = 0;i < messageHistory.length ; i++ ){
     var li = document.createElement("li");
     ul.appendChild(li);
     var txt;
     if(messageHistory[i].sender.toText() == user2_principal){
        txt = user2;
     }else{
       txt = "Me";
     }
     txt = txt+": "+messageHistory[i].content;
     var litxt = document.createTextNode(txt);
     li.appendChild(litxt);
   }
   console.log("get history done");
 });

 document.getElementById("sendMessage").addEventListener("click", async () => {
  let user2 = document.getElementById("toName").value;
  let user2_principal = await authActor.getPrincipalByUserName(user2);
  var content = document.getElementById("message").value;
  let sta = await authActor.sendMessage(user2_principal,content);
  var ul=document.getElementById("messageWindow");
  var li= document.createElement("li");
  ul.appendChild(li);
  var txt = "Me: "+document.getElementById("message").value ;
  var litxt = document.createTextNode(txt);
  li.appendChild(litxt);
  console.log("sent");
  document.getElementById("message").value = "";
});



