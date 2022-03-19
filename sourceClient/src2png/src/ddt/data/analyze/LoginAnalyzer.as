// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LoginAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ChurchManager;
    import ddt.data.ChurchRoomInfo;
    import im.IMController;

    public class LoginAnalyzer extends DataAnalyzer 
    {

        public var tempPassword:String;

        public function LoginAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_2:XML = new XML(_arg_1);
            var _local_3:String = _local_2.@value;
            message = _local_2.@message;
            if (_local_3 == "true")
            {
                PlayerManager.Instance.Self.beginChanges();
                ObjectUtils.copyPorpertiesByXML(PlayerManager.Instance.Self, _local_2..Item[0]);
                PlayerManager.Instance.Self.commitChanges();
                PlayerManager.Instance.Account.Password = this.tempPassword;
                ChurchManager.instance.selfRoom = ((_local_2..Item[0].@IsCreatedMarryRoom == "false") ? null : new ChurchRoomInfo());
                onAnalyzeComplete();
                IMController.Instance.setupRecentContactsList();
            }
            else
            {
                onAnalyzeError();
            };
        }


    }
}//package ddt.data.analyze

