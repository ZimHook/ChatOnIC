import User "../Module/User";
import Message "../Module/Message";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";
import TrieSet "mo:base/TrieSet";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

module{
    type User = User.User;
    type ShowUser = User.showUser;
    type Message = Message.Message;

    public class userDB(){

        private var userDB = HashMap.HashMap<Principal, User>(1, Principal.equal, Principal.hash);

        private var userName2Uid = HashMap.HashMap<Text, Principal>(1, Text.equal, Text.hash);

        private var bioMap = HashMap.HashMap<Principal,Text>(1, Principal.equal, Principal.hash);


        public func addUser(user : User) : Bool{
            if(isUserExist(user.uid) or isUserNameUsed(user.username) or Text.size(user.username) >= 20){
                false
            }else{
                userDB.put(user.uid, user);
                userName2Uid.put(user.username, user.uid);
                true
            }
        };


        public func deleteUser(uid : Principal) : Bool{
            if(isUserExist(uid)){
                userDB.delete(uid);
                bioMap.delete(uid);
                switch(getUserNameByPrincipal(uid)){
                    case null{
                    };
                    case(?text){
                        userName2Uid.delete(text);
                    };
                };
                true
            }else{
                false
            }
        };

        public func changeUserProfile(oper_uid : Principal, user : User) : Bool{
            if(isUserExist(oper_uid) and oper_uid == user.uid){
                switch(userName2Uid.get(user.username)){
                    case null{
                        ignore userDB.replace(oper_uid, user);
                        ignore userName2Uid.replace(user.username, oper_uid);
                        return true;
                    };
                    case(?principal){
                        if(principal == user.uid){
                            ignore userDB.replace(oper_uid, user);
                            ignore userName2Uid.replace(user.username, oper_uid);
                            return true;
                        }else{
                            return false;
                        }
                    };
                };
            }else{
                false
            }
        };


        public func getUserProfile(uid : Principal) : ?User{
            switch(userDB.get(uid)){
                case (?user){ ?user };
                case(_) { null };
            }
        };

        public func getShowUserProfile(uid : Principal) : ?ShowUser{
            switch(userDB.get(uid)){
                case (?user){ 
                     ?{
                        uid = user.uid;
                        nickname = user.nickname;
                        username = user.username;
                        avatarimg = user.avatarimg;
                        bio = getBio(user.uid);
                     }
                };
                case(_) { null };
            }
        };


        public func isUserExist(uid : Principal) : Bool{
            switch(userDB.get(uid)){
                case(?user){ true };
                case(_){ false };
            }
        };

        
        public func isUserNameUsed(userName : Text) : Bool{
            switch(userName2Uid.get(userName)){
                case null{
                    false
                };
                case(?principal){
                    true
                }
            };
        };

        public func getPrincipalByUserName(userName : Text) : ?Principal{
            switch(userName2Uid.get(userName)){
                case null{
                    null
                };
                case(?principal){
                    Option.make<Principal>(principal)
                };
            };
        };

        public func getUserNameByPrincipal(uid : Principal) : ?Text{
            switch(userDB.get(uid)){
                case null{
                    null
                };
                case(?user){
                    Option.make<Text>(user.username)
                };
            };
        };
        //---------------------bio----------------------
        public func putBio(uid : Principal, bioText : Text) {
            if(isUserExist(uid))
            bioMap.put(uid, bioText);
        };

        public func getBio(uid : Principal) : Text{
            switch(bioMap.get(uid)){
                case null{
                    "这个人很懒，什么都没有留下~"
                };
                case(?text){
                    text
                };
            };
        };

    };
};