import type { Principal } from '@dfinity/principal';
export type Avatarimg = string;
export type BIO = string;
export type Content = string;
export interface Message {
  'content' : Content,
  'time' : Time,
  'sender' : Principal,
}
export type NickName = string;
export interface ShowUser {
  'bio' : BIO,
  'uid' : UID,
  'nickname' : NickName,
  'username' : UserName,
  'avatarimg' : Avatarimg,
}
export type Time = bigint;
export type UID = Principal;
export interface User {
  'uid' : UID,
  'nickname' : NickName,
  'username' : UserName,
  'avatarimg' : Avatarimg,
}
export type UserName = string;
export interface _SERVICE {
  'addUser' : (arg_0: string, arg_1: string, arg_2: string) => Promise<boolean>,
  'changeUserProfile' : (
      arg_0: string,
      arg_1: string,
      arg_2: string,
    ) => Promise<boolean>,
  'deleteUser' : () => Promise<boolean>,
  'getPreviousMessage' : (arg_0: Principal) => Promise<Array<Message>>,
  'getPreviousMessage_mail' : (arg_0: Principal) => Promise<Array<Message>>,
  'getPrincipalByUserName' : (arg_0: string) => Promise<Principal>,
  'getShowUserProfileByPrincipal' : () => Promise<ShowUser>,
  'getShowUserProfileByUserName' : (arg_0: string) => Promise<ShowUser>,
  'getUserNameByPrincipal' : (arg_0: Principal) => Promise<string>,
  'getUserProfile' : () => Promise<User>,
  'isUserExist' : () => Promise<boolean>,
  'isUserNameUsed' : (arg_0: string) => Promise<boolean>,
  'sendMessage' : (arg_0: Principal, arg_1: string) => Promise<boolean>,
  'sendMessage_mail' : (arg_0: Principal, arg_1: string) => Promise<boolean>,
}
