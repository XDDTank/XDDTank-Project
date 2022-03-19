// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//invite.view.NavigationList

package invite.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ListPanel;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;

    public class NavigationList extends Sprite implements Disposeable 
    {

        private var _type:int;
        private var _modeArr:Array;
        private var _buttons:Array;
        private var _list:ListPanel;
        private var _listBack:DisplayObject;
        private var _listArr:Array;

        public function NavigationList()
        {
            this.configUI();
        }

        private function configUI():void
        {
            this._listBack = ComponentFactory.Instance.creatComponentByStylename("invite.list.BackgroundList");
            addChild(this._listBack);
        }

        public function get type():int
        {
            return (this._type);
        }

        public function set type(_arg_1:int):void
        {
        }

        public function get list():Array
        {
            return (this._listArr);
        }

        public function set list(_arg_1:Array):void
        {
        }

        public function get mode():String
        {
            var _local_1:String = "";
            var _local_2:int;
            while (_local_2 < this._modeArr.length)
            {
                _local_1 = (_local_1 + (this._modeArr[_local_2] + ","));
                _local_2++;
            };
            return (_local_1.substr(0, (_local_1.length - 1)));
        }

        public function set mode(_arg_1:String):void
        {
            this._modeArr = _arg_1.split(",");
        }

        public function addNavButton(_arg_1:NavButton, _arg_2:int):void
        {
            var _local_3:ButtonProxy = new ButtonProxy();
            _local_3.button = _arg_1;
            _local_3.type = _arg_2;
            this._buttons.push(_local_3);
        }

        private function setNavigationPos(_arg_1:int):void
        {
        }

        public function dispose():void
        {
        }


    }
}//package invite.view

import invite.view.NavButton;

class ButtonProxy 
{

    public var button:NavButton;
    public var type:int;


}


