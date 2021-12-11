export const idlFactory = ({ IDL }) => {
  const Content = IDL.Text;
  const Time = IDL.Int;
  const Message = IDL.Record({
    'content' : Content,
    'time' : Time,
    'sender' : IDL.Principal,
  });
  const BIO = IDL.Text;
  const UID = IDL.Principal;
  const NickName = IDL.Text;
  const UserName = IDL.Text;
  const Avatarimg = IDL.Text;
  const ShowUser = IDL.Record({
    'bio' : BIO,
    'uid' : UID,
    'nickname' : NickName,
    'username' : UserName,
    'avatarimg' : Avatarimg,
  });
  const User = IDL.Record({
    'uid' : UID,
    'nickname' : NickName,
    'username' : UserName,
    'avatarimg' : Avatarimg,
  });
  return IDL.Service({
    'addUser' : IDL.Func([IDL.Text, IDL.Text, IDL.Text], [IDL.Bool], []),
    'changeUserProfile' : IDL.Func(
        [IDL.Text, IDL.Text, IDL.Text],
        [IDL.Bool],
        [],
      ),
    'deleteUser' : IDL.Func([], [IDL.Bool], []),
    'getPreviousMessage' : IDL.Func(
        [IDL.Principal],
        [IDL.Vec(Message)],
        ['query'],
      ),
    'getPreviousMessage_mail' : IDL.Func(
        [IDL.Principal],
        [IDL.Vec(Message)],
        ['query'],
      ),
    'getPrincipalByUserName' : IDL.Func([IDL.Text], [IDL.Principal], ['query']),
    'getShowUserProfileByPrincipal' : IDL.Func([], [ShowUser], ['query']),
    'getShowUserProfileByUserName' : IDL.Func(
        [IDL.Text],
        [ShowUser],
        ['query'],
      ),
    'getUserNameByPrincipal' : IDL.Func([IDL.Principal], [IDL.Text], ['query']),
    'getUserProfile' : IDL.Func([], [User], ['query']),
    'isUserExist' : IDL.Func([], [IDL.Bool], ['query']),
    'isUserNameUsed' : IDL.Func([IDL.Text], [IDL.Bool], ['query']),
    'sendMessage' : IDL.Func([IDL.Principal, IDL.Text], [IDL.Bool], []),
    'sendMessage_mail' : IDL.Func([IDL.Principal, IDL.Text], [IDL.Bool], []),
  });
};
export const init = ({ IDL }) => { return []; };
