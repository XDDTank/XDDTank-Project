// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DialogManager

package ddt.manager
{
    import com.pickgliss.ui.DialogManagerBase;
    import flash.events.Event;
    import ddt.view.character.ICharacter;
    import ddt.data.player.PlayerInfo;
    import ddt.data.player.SelfInfo;
    import ddt.view.character.CharactoryFactory;
    import ddt.utils.PositionUtils;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import flash.display.DisplayObject;

    public class DialogManager extends DialogManagerBase 
    {

        private static var _instance:DialogManager;

        public function DialogManager()
        {
            this.addEventListener(Event.COMPLETE, this.__enableChat);
        }

        public static function get Instance():DialogManager
        {
            if (_instance == null)
            {
                _instance = new (DialogManager)();
            };
            return (_instance);
        }


        override public function showDialog(_arg_1:int, _arg_2:Number=0, _arg_3:Boolean=true, _arg_4:Boolean=true, _arg_5:Boolean=true, _arg_6:int=4):void
        {
            super.showDialog(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            ChatManager.Instance.chatDisabled = true;
        }

        private function __enableChat(_arg_1:Event):void
        {
            ChatManager.Instance.chatDisabled = false;
        }

        override protected function Self(_arg_1:int):DisplayObject
        {
            var _local_2:ICharacter;
            var _local_3:PlayerInfo = new PlayerInfo();
            var _local_4:SelfInfo = PlayerManager.Instance.Self;
            _local_3.updateStyle(_local_4.Sex, _local_4.Hide, _local_4.getPrivateStyle(), _local_4.Colors, _local_4.getSkinColor());
            _local_3.WeaponID = PlayerManager.Instance.Self.WeaponID;
            _local_2 = CharactoryFactory.createCharacter(_local_3, "room");
            _local_2.showGun = true;
            _local_2.show(false, -1);
            _local_2.setShowLight(true);
            _local_2.scaleX = 1.4;
            _local_2.scaleY = 1.4;
            PositionUtils.setPos(_local_2, "dialog.headImgPos");
            var _local_5:ItemTemplateInfo = new ItemTemplateInfo();
            _local_5.TemplateID = -111;
            _local_5.CategoryID = EquipType.FACE;
            if (_arg_1 > 0)
            {
                _local_3.setPartStyle(_local_5, 0, _arg_1, "");
            };
            return (_local_2 as DisplayObject);
        }

        override protected function SelfName():String
        {
            return (PlayerManager.Instance.Self.NickName);
        }


    }
}//package ddt.manager

