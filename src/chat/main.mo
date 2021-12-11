import UserDB "./DB/UserDB";
import MessageDB "./DB/MessageDB";
import User "./Module/User";
import Message "./Module/Message";
import Error "mo:base/Error";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";

actor Chat{
    type User=User.User;
    type ShowUser = User.showUser;
    type Message = Message.Message;
    private var userDB = UserDB.userDB();
    private var messageDB = MessageDB.messageDB();

    public shared(msg) func addUser(username : Text,nickname : Text, avatarimg: Text) : async Bool{
        userDB.addUser({
            uid = msg.caller;
            nickname =nickname;
            username = username;
            avatarimg = avatarimg;
        })
    };

     public shared(msg) func deleteUser() : async Bool{
        userDB.deleteUser(msg.caller)
    };

    public query(msg) func isUserExist() : async Bool{
        userDB.isUserExist(msg.caller)
    };public shared query(msg) func getUserProfile() : async User{
        switch(userDB.getUserProfile(msg.caller)){
            case(?user){ user };
            case(_){ throw Error.reject("no such user") };
        }
    };

    public shared query(msg) func getShowUserProfileByPrincipal() : async ShowUser{
        switch(userDB.getShowUserProfile(msg.caller)){
            case(?showuser){ showuser };
            case(_){ throw Error.reject("no such user") };
        }
    };

    public query func isUserNameUsed(userName : Text) : async Bool{
        userDB.isUserNameUsed(userName)
    };

    public shared(msg) func changeUserProfile(nickname : Text, username : Text, avatarimg : Text) : async Bool{
        userDB.changeUserProfile(msg.caller, {
            uid = msg.caller;
            nickname = nickname;
            username = username;
            avatarimg = avatarimg;
        })
    };

    public query func getPrincipalByUserName(userName : Text) : async Principal{
        var uid = switch(userDB.getPrincipalByUserName(userName)){
            case null{throw Error.reject("can't find this username")};
            case(?principal){principal};
        };
        return uid;
    };

    public query func getUserNameByPrincipal(uid: Principal) : async Text{
        switch(userDB.getUserNameByPrincipal(uid)){
            case null{throw Error.reject("can't find this user")};
            case(?text){text};
        }
    };

    public query func getShowUserProfileByUserName(userName : Text) : async ShowUser{
        var uid = switch(userDB.getPrincipalByUserName(userName)){
            case null{throw Error.reject("can't find this username")};
            case(?principal){principal};
        };
        switch(userDB.getShowUserProfile(uid)){
            case(?showuser){ showuser };
            case(_){ throw Error.reject("no such user") };
        }
    };

    //==============MessageDB===============

    public shared(msg) func sendMessage(reciver : Principal, content : Text) : async Bool{
        let sender_name = switch(userDB.getUserNameByPrincipal(msg.caller)){
            case null{throw Error.reject("can't find this user")};
            case(?text){text};
        };
        let reciver_name = switch(userDB.getUserNameByPrincipal(reciver)){
            case null{throw Error.reject("can't find this user")};
            case(?text){text};
        };
        messageDB.sendMessage(sender_name,reciver_name,{
            sender = msg.caller;
            content = content;
            time = Time.now();
        })
    };

    public query(msg) func getPreviousMessage(user : Principal) : async [Message]{
        let user1_name = switch(userDB.getUserNameByPrincipal(msg.caller)){
            case null{throw Error.reject("can't find this user")};
            case(?text){text};
        };
        let user2_name = switch(userDB.getUserNameByPrincipal(user)){
            case null{throw Error.reject("can't find this user")};
            case(?text){text};
        };
        messageDB.getPreviousMessage({
            user1 = user1_name;
            user2 = user2_name;
        })
    };

    public shared(msg) func sendMessage_mail(reciver : Principal, content : Text) : async Bool{
        messageDB.sendMessage_mail(reciver,{
            sender = msg.caller;
            content = content;
            time = Time.now();
        })
    };

    public query(msg) func getPreviousMessage_mail(user : Principal) : async [Message]{
        messageDB.getPreviousMessage_mail(msg.caller, user);
    };


};
