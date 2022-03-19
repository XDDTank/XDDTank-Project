// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//login.view.ConsortiaRenameFrame

package login.view
{
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.data.AccountInfo;
    import flash.utils.ByteArray;
    import ddt.utils.CrytoUtils;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.Version;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.RequestLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import flash.events.Event;

    public class ConsortiaRenameFrame extends RoleRenameFrame 
    {

        public function ConsortiaRenameFrame()
        {
            _path = "RenameConsortiaName.ashx";
            _checkPath = "ConsortiaNameCheck.ashx";
            _resultString = LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert");
            _resultField.text = _resultString;
        }

        override protected function configUi():void
        {
            super.configUi();
            titleText = LanguageMgr.GetTranslation("tank.loginstate.guildNameModify");
            _nicknameLabel.text = LanguageMgr.GetTranslation("tank.loginstate.guildNameModify");
            if (_nicknameField)
            {
                _nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.ConsortianameInput");
                addToContent(_nicknameField);
            };
        }

        override protected function __onModifyClick(_arg_1:MouseEvent):void
        {
            super.__onModifyClick(_arg_1);
        }

        override protected function doRename():void
        {
            var _local_1:AccountInfo = PlayerManager.Instance.Account;
            var _local_2:Date = new Date();
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeShort(_local_2.fullYearUTC);
            _local_3.writeByte((_local_2.monthUTC + 1));
            _local_3.writeByte(_local_2.dateUTC);
            _local_3.writeByte(_local_2.hoursUTC);
            _local_3.writeByte(_local_2.minutesUTC);
            _local_3.writeByte(_local_2.secondsUTC);
            var _local_4:String = "";
            var _local_5:int;
            while (_local_5 < 6)
            {
                _local_4 = (_local_4 + w.charAt(int((Math.random() * 26))));
                _local_5++;
            };
            _local_3.writeUTFBytes(((((((((_local_1.Account + ",") + _local_1.Password) + ",") + _local_4) + ",") + _roleInfo.NickName) + ",") + _newName));
            var _local_6:String = CrytoUtils.rsaEncry4(_local_1.Key, _local_3);
            var _local_7:URLVariables = RequestVairableCreater.creatWidthKey(false);
            _local_7["p"] = _local_6;
            _local_7["v"] = Version.Build;
            _local_7["site"] = PathManager.solveConfigSite();
            var _local_8:RequestLoader = this.createModifyLoader(_path, _local_7, _local_4, renameCallBack);
            LoadResourceManager.instance.startLoad(_local_8);
        }

        override protected function createModifyLoader(_arg_1:String, _arg_2:URLVariables, _arg_3:String, _arg_4:Function):RequestLoader
        {
            return (super.createModifyLoader(_arg_1, _arg_2, _arg_3, _arg_4));
        }

        override protected function renameComplete():void
        {
            _roleInfo.ConsortiaNameChanged = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }


    }
}//package login.view

