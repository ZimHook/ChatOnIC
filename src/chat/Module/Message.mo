import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Hash "mo:base/Hash";
import Nat32 "mo:base/Nat32";

module {


    public type Content = Text;

    public type Time = Time.Time;

    public type Message = {
        sender : Principal;
        content : Content;
        time : Time;
    };
    
    public type UserCombine = {
        user1 : Text;
        user2 : Text;
    };

    //使用username字符串补全到32位长度，相加求hash
    public func userCombineHash(userCombine : UserCombine) : Hash.Hash {
        var user1_text = userCombine.user1;
        while(Text.size(user1_text) < 32){
            user1_text := user1_text # "@";
        };
        var user2_text = userCombine.user2;
        while(Text.size(user2_text) < 32){
            user2_text := user2_text # "@";
        };
        let combine = user1_text # user2_text;
        return Text.hash(combine);
    };

    public func userCombineEqual(userCombine1 : UserCombine, userCombine2 : UserCombine) : Bool {
        if(userCombine1.user1 == userCombine2.user1 and userCombine1.user2 == userCombine2.user2){return true};
        if(userCombine1.user1 == userCombine2.user2 and userCombine1.user2 == userCombine2.user1){return true};
        return false;
    };


    public class defaultType(){
        private let defaultPrincipal : Principal = Principal.fromText("r7inp-6aaaa-aaaaa-aaabq-cai");
        public let defaultMessage : Message = {
            sender = defaultPrincipal;
            content = "";
            time = Time.now();
        };
    };


};