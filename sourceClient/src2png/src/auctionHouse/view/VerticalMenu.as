// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.VerticalMenu

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class VerticalMenu extends Sprite implements Disposeable 
    {

        public static const MENU_CLICKED:String = "menuClicked";
        public static const MENU_REFRESH:String = "menuRefresh";

        private var tabWidth:Number;
        private var l1Width:Number;
        private var l2Width:Number;
        private var subMenus:Array;
        private var rootMenu:Array;
        public var currentItem:IMenuItem;
        public var isseach:Boolean;
        private var _height:int;

        public function VerticalMenu(_arg_1:Number, _arg_2:Number, _arg_3:Number)
        {
            this.tabWidth = _arg_1;
            this.l1Width = _arg_2;
            this.l2Width = _arg_3;
            this.rootMenu = [];
            this.subMenus = [];
        }

        public function addItemAt(_arg_1:IMenuItem, _arg_2:int=-1):void
        {
            var _local_3:uint;
            if (_arg_2 == -1)
            {
                this.rootMenu.push(_arg_1);
                _arg_1.addEventListener(MouseEvent.CLICK, this.rootMenuClickHandler);
            }
            else
            {
                if ((!(this.subMenus[_arg_2])))
                {
                    _local_3 = 0;
                    while (_local_3 <= _arg_2)
                    {
                        if ((!(this.subMenus[_local_3])))
                        {
                            this.subMenus[_local_3] = [];
                        };
                        _local_3++;
                    };
                };
                _arg_1.x = this.tabWidth;
                _arg_1.addEventListener(MouseEvent.CLICK, this.subMenuClickHandler);
                this.subMenus[_arg_2].push(_arg_1);
            };
            addChild((_arg_1 as DisplayObject));
            this.closeAll();
        }

        public function closeAll():void
        {
            var _local_3:uint;
            var _local_1:uint;
            while (_local_1 < this.rootMenu.length)
            {
                this.rootMenu[_local_1].y = (_local_1 * this.l1Width);
                this.rootMenu[_local_1].isOpen = false;
                this.rootMenu[_local_1].enable = true;
                _local_1++;
            };
            var _local_2:uint;
            while (_local_2 < this.subMenus.length)
            {
                _local_3 = 0;
                while (_local_3 < this.subMenus[_local_2].length)
                {
                    this.subMenus[_local_2][_local_3].visible = false;
                    this.subMenus[_local_2][_local_3].y = 0;
                    _local_3++;
                };
                _local_2++;
            };
            this._height = (this.rootMenu.length * this.l1Width);
        }

        public function get $height():Number
        {
            return (this._height);
        }

        protected function rootMenuClickHandler(_arg_1:MouseEvent):void
        {
            var _local_3:uint;
            var _local_4:uint;
            SoundManager.instance.play("008");
            if (this.currentItem != null)
            {
                this.currentItem.enable = true;
            };
            this.currentItem = (_arg_1.currentTarget as IMenuItem);
            var _local_2:int = this.rootMenu.indexOf(this.currentItem);
            if (this.currentItem.isOpen)
            {
                this.closeAll();
                this.currentItem.enable = true;
                _local_3 = 0;
                while (_local_3 < this.subMenus.length)
                {
                    _local_4 = 0;
                    while (_local_4 < this.subMenus[_local_3].length)
                    {
                        this.subMenus[_local_3][_local_4].enable = true;
                        _local_4++;
                    };
                    _local_3++;
                };
            }
            else
            {
                this.closeAll();
                this.openItemByIndex(_local_2);
                this.isseach = false;
                this.currentItem.enable = false;
            };
            dispatchEvent(new Event(MENU_REFRESH));
        }

        private function closeItems():void
        {
        }

        private function openItemByIndex(_arg_1:uint):void
        {
            var _local_4:uint;
            if ((!(this.subMenus[_arg_1])))
            {
                return;
            };
            var _local_2:uint;
            while (_local_2 < this.rootMenu.length)
            {
                if (_local_2 <= _arg_1)
                {
                    this.rootMenu[_local_2].y = (_local_2 * this.l1Width);
                }
                else
                {
                    this.rootMenu[_local_2].y = ((_local_2 * this.l1Width) + (this.subMenus[_arg_1].length * this.l2Width));
                };
                _local_2++;
            };
            var _local_3:uint;
            while (_local_3 < this.subMenus.length)
            {
                _local_4 = 0;
                while (_local_4 < this.subMenus[_local_3].length)
                {
                    if (_local_3 == _arg_1)
                    {
                        this.subMenus[_local_3][_local_4].visible = true;
                        this.subMenus[_local_3][_local_4].enable = true;
                        this.subMenus[_local_3][_local_4].y = (((_arg_1 + 1) * this.l1Width) + (_local_4 * this.l2Width));
                    }
                    else
                    {
                        this.subMenus[_local_3][_local_4].visible = false;
                    };
                    _local_4++;
                };
                _local_3++;
            };
            this._height = ((this.rootMenu.length * this.l1Width) + (this.subMenus[_arg_1].length * this.l2Width));
            this.rootMenu[_arg_1].isOpen = true;
        }

        public function dispose():void
        {
            var _local_1:uint;
            var _local_2:uint;
            var _local_3:uint;
            if (this.rootMenu)
            {
                _local_1 = 0;
                while (_local_1 < this.rootMenu.length)
                {
                    this.rootMenu[_local_1].removeEventListener(MouseEvent.CLICK, this.rootMenuClickHandler);
                    ObjectUtils.disposeObject(this.rootMenu[_local_1]);
                    this.rootMenu[_local_1] = null;
                    _local_1++;
                };
            };
            this.rootMenu = null;
            if (this.subMenus)
            {
                _local_2 = 0;
                while (_local_2 < this.subMenus.length)
                {
                    _local_3 = 0;
                    while (_local_3 < this.subMenus[_local_2].length)
                    {
                        this.subMenus[_local_2][_local_3].removeEventListener(MouseEvent.CLICK, this.subMenuClickHandler);
                        ObjectUtils.disposeObject(this.subMenus[_local_2][_local_3]);
                        this.subMenus[_local_2][_local_3] = null;
                        _local_3++;
                    };
                    _local_2++;
                };
            };
            this.subMenus = null;
            this.currentItem = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        protected function subMenuClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.isseach = true;
            if (this.currentItem)
            {
                this.currentItem.enable = true;
            };
            this.currentItem = (_arg_1.currentTarget as IMenuItem);
            this.currentItem.enable = false;
            dispatchEvent(new Event(MENU_CLICKED));
        }


    }
}//package auctionHouse.view

