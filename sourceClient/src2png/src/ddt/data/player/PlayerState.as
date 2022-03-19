// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.PlayerState

package ddt.data.player
{
    import ddt.manager.PlayerManager;
    import ddt.manager.SharedManager;
    import ddt.manager.LanguageMgr;

    public class PlayerState 
    {

        public static const OFFLINE:int = 0;
        public static const ONLINE:int = 1;
        public static const AWAY:int = 2;
        public static const BUSY:int = 3;
        public static const SHOPPING:int = 4;
        public static const NO_DISTRUB:int = 5;
        public static const AUTO:int = 0;
        public static const MANUAL:int = 1;

        private var _stateID:int;
        private var _autoReply:String;
        private var _priority:int;

        public function PlayerState(_arg_1:int, _arg_2:int=0)
        {
            this._stateID = _arg_1;
            this._priority = _arg_2;
        }

        public function get StateID():int
        {
            return (this._stateID);
        }

        public function get Priority():int
        {
            return (this._priority);
        }

        public function get AutoReply():String
        {
            switch (this._stateID)
            {
                case AWAY:
                    if (SharedManager.Instance.awayAutoReply[PlayerManager.Instance.Self.ID] != undefined)
                    {
                        return (SharedManager.Instance.awayAutoReply[PlayerManager.Instance.Self.ID]);
                    };
                    return (LanguageMgr.GetTranslation("im.playerState.awayReply"));
                case BUSY:
                    if (SharedManager.Instance.busyAutoReply[PlayerManager.Instance.Self.ID] != undefined)
                    {
                        return (SharedManager.Instance.busyAutoReply[PlayerManager.Instance.Self.ID]);
                    };
                    return (LanguageMgr.GetTranslation("im.playerState.busyReply"));
                case NO_DISTRUB:
                    if (SharedManager.Instance.noDistrubAutoReply[PlayerManager.Instance.Self.ID] != undefined)
                    {
                        return (SharedManager.Instance.noDistrubAutoReply[PlayerManager.Instance.Self.ID]);
                    };
                    return (LanguageMgr.GetTranslation("im.playerState.noDisturbReply"));
                case SHOPPING:
                    if (SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID] != undefined)
                    {
                        return (SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID]);
                    };
                    return (LanguageMgr.GetTranslation("im.playerState.shoppingReply"));
            };
            return ("");
        }

        public function set AutoReply(_arg_1:String):void
        {
            switch (this._stateID)
            {
                case AWAY:
                    SharedManager.Instance.awayAutoReply[PlayerManager.Instance.Self.ID] = _arg_1;
                    break;
                case BUSY:
                    SharedManager.Instance.busyAutoReply[PlayerManager.Instance.Self.ID] = _arg_1;
                    break;
                case NO_DISTRUB:
                    SharedManager.Instance.noDistrubAutoReply[PlayerManager.Instance.Self.ID] = _arg_1;
                    break;
                case SHOPPING:
                    SharedManager.Instance.shoppingAutoReply[PlayerManager.Instance.Self.ID] = _arg_1;
                    break;
            };
            SharedManager.Instance.save();
        }

        public function convertToString():String
        {
            switch (this._stateID)
            {
                case AWAY:
                    return (LanguageMgr.GetTranslation("im.playerState.away"));
                case OFFLINE:
                    return (LanguageMgr.GetTranslation("im.playerState.offline"));
                case BUSY:
                    return (LanguageMgr.GetTranslation("im.playerState.busy"));
                case NO_DISTRUB:
                    return (LanguageMgr.GetTranslation("im.playerState.noDisturb"));
                case ONLINE:
                    return (LanguageMgr.GetTranslation("im.playerState.online"));
                case SHOPPING:
                    return (LanguageMgr.GetTranslation("im.playerState.shopping"));
            };
            return ("未知");
        }


    }
}//package ddt.data.player

