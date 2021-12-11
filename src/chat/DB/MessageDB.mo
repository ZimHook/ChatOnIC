import Message "../Module/Message";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

module{
    type Message = Message.Message;
    type UserCombine = Message.UserCombine;

    public class messageDB(){

        //每个对话创建一个索引
        private var messageBox = HashMap.HashMap<UserCombine,[Message]>(1, Message.userCombineEqual, Message.userCombineHash);

        public func sendMessage(sender : Text, reciver : Text, message : Message) : Bool{
            switch(messageBox.get({user1 = sender; user2 = reciver})){
                case (?array){
                    var newArray = Array.append<Message>(array,Array.make<Message>(message));
                    ignore messageBox.replace({user1 = sender; user2 = reciver},newArray);
                    return true;
                };
                case null{
                    messageBox.put({user1 = sender; user2 = reciver},Array.make<Message>(message));
                    return true;
                };
            };
            return false;
        };

        public func getPreviousMessage(userCombine : UserCombine) : [Message]{
            switch(messageBox.get(userCombine)){
                case (?array){
                    return array;
                };
                case null{return []};
            };
        };

        // 以下为邮箱方式实现, 测试功能良好，不过实际应用效率应该不高
        private var messageBox_mail = HashMap.HashMap<Principal,[Message]>(1, Principal.equal, Principal.hash);

        public func sendMessage_mail(reciver : Principal, message : Message) : Bool{
            switch(messageBox_mail.get(reciver)){
                case(?array){
                    var newArray = Array.append<Message>(array,Array.make<Message>(message));
                    ignore messageBox_mail.replace(reciver,newArray);
                    return true;
                };
                case null{
                    messageBox_mail.put(reciver,Array.make<Message>(message));
                    return true;
                };
            };
            return false;
        };

        public func getPreviousMessage_mail(user1 : Principal, user2 : Principal) : [Message]{
            var arr1 : [Message] = [];
            var arr2 : [Message] = [];
            var size1 = 0;
            var size2 = 0;
            switch(messageBox_mail.get(user1)){
                case(?array){
                    for (x in array.vals()){
                        if(x.sender == user1){
                            arr1 := Array.append<Message>(arr1, Array.make<Message>(x));
                            size1 += 1;
                        };
                    };
                };
                case null{};
            };
            switch(messageBox_mail.get(user2)){
                case(?array){
                    for (x in array.vals()){
                        if(x.sender == user2){
                            arr2 := Array.append<Message>(arr2, Array.make<Message>(x));
                            size2 += 1;
                        };
                    };
                };
                case null{};
            };
            var allMessage = Array.init<Message>(size1+size2, Message.defaultType().defaultMessage);
            var index = 0;
            while(size1 > 0 and size2 > 0){
                if(arr1[size1-1].time < arr2[size2-1].time){
                    allMessage[index] := arr1[size1-1];
                    size1 -= 1;
                    index += 1;
                }else{
                    allMessage[index] := arr2[size2-1];
                    size2 -= 1;
                    index += 1;
                };
            };
            while(size1 > 0){
                allMessage[index] := arr1[size1-1];
                    size1 -= 1;
                    index += 1;
            };
            while(size2 > 0){
                allMessage[index] := arr2[size2-1];
                    size2 -= 1;
                    index += 1;
            };
            return Array.freeze<Message>(allMessage);
        };
    };
};