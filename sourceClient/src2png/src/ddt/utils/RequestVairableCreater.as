// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.RequestVairableCreater

package ddt.utils
{
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.MD5;

    public class RequestVairableCreater 
    {


        public static function creatWidthKey(_arg_1:Boolean):URLVariables
        {
            var _local_2:URLVariables = new URLVariables();
            _local_2["selfid"] = PlayerManager.Instance.Self.ID;
            _local_2["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
            if (_arg_1)
            {
                _local_2["rnd"] = Math.random();
            };
            return (_local_2);
        }


    }
}//package ddt.utils

