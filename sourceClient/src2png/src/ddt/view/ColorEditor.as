// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.ColorEditor

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.ColorEnum;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;

    [Event(name="change", type="flash.events.Event")]
    public class ColorEditor extends Sprite implements Disposeable 
    {

        public static const REDUCTIVE_COLOR:String = "reductiveColor";
        public static const CHANGE_COLOR:String = "change_color";

        private var _colors:Array;
        private var _skins:Array;
        private var _colorsArr:Array;
        private var _skinsArr:Array;
        private var _colorlist:SimpleTileList;
        private var _skincolorlist:SimpleTileList;
        private var _colorBtn:SelectedButton;
        private var _textureBtn:SelectedButton;
        private var _restoreColorBtn:BaseButton;
        private var _colorPanelMask:Bitmap;
        private var _colorPanelBg:Bitmap;
        private var _colorPanelBgI:Scale9CornerImage;
        private var _btnGroup:SelectedButtonGroup;
        private var _ciGroup:SelectedButtonGroup;
        private var _siGroup:SelectedButtonGroup;
        private var _colorRestorable:Boolean;
        private var _skinRestorable:Boolean;
        private var _selectedColor:int;
        private var _selectedSkin:int;

        public function ColorEditor()
        {
            this._selectedColor = -1;
            this._selectedSkin = -1;
            this._btnGroup = new SelectedButtonGroup();
            this._colorBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ColorBtn");
            this._textureBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TextureBtn");
            this._restoreColorBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ReductiveColorBtn");
            this._colorPanelBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.ColorChoosePanel");
            this._colorPanelMask = ComponentFactory.Instance.creatBitmap("asset.ddtshop.ColorMask");
            this._colorPanelBgI = ComponentFactory.Instance.creatComponentByStylename("ddt.shop.changeColor.leftViewBgI");
            this._colors = ColorEnum.COLORS;
            this._skins = ColorEnum.SKIN_COLORS;
            this._colorsArr = new Array();
            this._skinsArr = new Array();
            this._colorlist = new SimpleTileList(14);
            this._skincolorlist = new SimpleTileList(14);
            this._colorlist.vSpace = (this._colorlist.hSpace = (this._skincolorlist.vSpace = (this._skincolorlist.hSpace = 1)));
            this._btnGroup.addSelectItem(this._colorBtn);
            this._btnGroup.addSelectItem(this._textureBtn);
            PositionUtils.setPos(this._colorlist, "shop.ColorPanelPos");
            PositionUtils.setPos(this._skincolorlist, "shop.ColorPanelPos");
            addChild(this._colorPanelBgI);
            addChild(this._colorPanelBg);
            addChild(this._colorBtn);
            addChild(this._textureBtn);
            addChild(this._restoreColorBtn);
            addChild(this._colorlist);
            addChild(this._skincolorlist);
            this._colorBtn.addEventListener(MouseEvent.CLICK, this.__colorEditClick);
            this._textureBtn.addEventListener(MouseEvent.CLICK, this.__skinEditClick);
            this._restoreColorBtn.addEventListener(MouseEvent.CLICK, this.__restoreColorBtnClick);
            this.colorEditable = true;
            this.skinEditable = false;
            this._ciGroup = new SelectedButtonGroup(true);
            this._siGroup = new SelectedButtonGroup(true);
            this.initColors();
            addChild(this._colorPanelMask);
        }

        private function initColors():void
        {
            var _local_3:ColorItem;
            var _local_4:ColorItem;
            var _local_1:int;
            while (_local_1 < this._colors.length)
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("shop.ColorItem");
                _local_3.setup(this._colors[_local_1]);
                this._colorsArr.push(_local_3);
                this._colorlist.addChild(_local_3);
                this._ciGroup.addSelectItem(_local_3);
                _local_3.addEventListener(MouseEvent.MOUSE_DOWN, this.__colorItemClick);
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._skins.length)
            {
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("shop.ColorItem");
                _local_4.setup(this._skins[_local_2]);
                this._skinsArr.push(_local_4);
                this._skincolorlist.addChild(_local_4);
                this._siGroup.addSelectItem(_local_4);
                _local_4.addEventListener(MouseEvent.MOUSE_DOWN, this.__skinItemClick);
                _local_2++;
            };
        }

        public function reset():void
        {
            this._selectedColor = -1;
            this._selectedSkin = -1;
            this._ciGroup.selectIndex = -1;
            this._siGroup.selectIndex = -1;
            this._colorRestorable = false;
            this._skinRestorable = false;
        }

        public function get colorRestorable():Boolean
        {
            return (this._colorRestorable);
        }

        public function set colorRestorable(_arg_1:Boolean):void
        {
            this._colorRestorable = _arg_1;
            if (((this.colorEditable) && (this.selectedType == 1)))
            {
                this._restoreColorBtn.enable = this._colorRestorable;
            };
        }

        public function get skinRestorable():Boolean
        {
            return (this._skinRestorable);
        }

        public function set skinRestorable(_arg_1:Boolean):void
        {
            this._skinRestorable = _arg_1;
            if (((this.skinEditable) && (this.selectedType == 2)))
            {
                this._restoreColorBtn.enable = this._skinRestorable;
            };
        }

        public function set restorable(_arg_1:Boolean):void
        {
            this._restoreColorBtn.visible = _arg_1;
        }

        public function get colorEditable():Boolean
        {
            return (this._colorBtn.enable);
        }

        public function set colorEditable(_arg_1:Boolean):void
        {
            if (this._colorBtn.enable != _arg_1)
            {
                this._colorBtn.enable = _arg_1;
                if (((!(_arg_1)) && (this._colorlist.visible)))
                {
                    this._colorlist.visible = false;
                    this._colorPanelMask.visible = true;
                };
            };
            this.updateReductiveColorBtn();
        }

        public function get skinEditable():Boolean
        {
            return (this._textureBtn.enable);
        }

        public function set skinEditable(_arg_1:Boolean):void
        {
            if (this._textureBtn.enable != _arg_1)
            {
                this._textureBtn.enable = _arg_1;
                if (((!(_arg_1)) && (this._skincolorlist.visible)))
                {
                    this._skincolorlist.visible = false;
                    this._colorPanelMask.visible = true;
                };
            };
            this.updateReductiveColorBtn();
        }

        private function updateReductiveColorBtn():void
        {
            if (((!(this.colorEditable)) && (!(this.skinEditable))))
            {
                this._restoreColorBtn.enable = false;
            }
            else
            {
                this._restoreColorBtn.enable = true;
            };
        }

        public function editColor(_arg_1:int=-1):void
        {
            if (this.colorEditable)
            {
                this.selectedColor = _arg_1;
                this._colorlist.visible = true;
                this._restoreColorBtn.enable = ((!(this._selectedColor == -1)) || (this._colorRestorable));
                this._skincolorlist.visible = false;
                this._colorPanelMask.visible = false;
                if (_arg_1 == -1)
                {
                    this._ciGroup.selectIndex = -1;
                };
            };
        }

        public function editSkin(_arg_1:int=-1):void
        {
            if (this.skinEditable)
            {
                this.selectedSkin = _arg_1;
                this._colorlist.visible = false;
                this._restoreColorBtn.enable = ((!(this._selectedSkin == -1)) || (this._skinRestorable));
                this._skincolorlist.visible = true;
                this._colorPanelMask.visible = false;
                if (_arg_1 == -1)
                {
                    this._siGroup.selectIndex = -1;
                };
            };
        }

        public function get selectedType():int
        {
            return (this._btnGroup.selectIndex + 1);
        }

        public function set selectedType(_arg_1:int):void
        {
            this._btnGroup.selectIndex = (_arg_1 - 1);
            if (this._btnGroup.selectIndex)
            {
                this.editColor(this.selectedColor);
            }
            else
            {
                this.editSkin(this.selectedSkin);
            };
        }

        public function get selectedColor():int
        {
            return (this._selectedColor);
        }

        public function set selectedColor(_arg_1:int):void
        {
            if (((!(_arg_1 == this._selectedColor)) && (this.colorEditable)))
            {
                this._selectedColor = _arg_1;
                this._colorlist.selectedIndex = this._colors.indexOf(_arg_1);
                this.updateReductiveColorBtn();
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        public function get selectedSkin():int
        {
            return (this._selectedSkin);
        }

        public function set selectedSkin(_arg_1:int):void
        {
            if (((!(_arg_1 == this._selectedSkin)) && (this.skinEditable)))
            {
                this._selectedSkin = _arg_1;
                this._skincolorlist.selectedIndex = this._skins.indexOf(_arg_1);
                this.updateReductiveColorBtn();
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        public function resetColor():void
        {
            this._selectedColor = -1;
            this._colorRestorable = false;
        }

        public function resetSkin():void
        {
            this._selectedSkin = -1;
            this._skinRestorable = false;
            this._skincolorlist.selectedIndex = this._skins.indexOf(this._selectedSkin);
        }

        private function __colorItemClick(_arg_1:Event):void
        {
            SoundManager.instance.play("047");
            var _local_2:ColorItem = (_arg_1.currentTarget as ColorItem);
            this.selectedColor = _local_2.getColor();
            dispatchEvent(new Event(CHANGE_COLOR));
        }

        private function __skinItemClick(_arg_1:Event):void
        {
            SoundManager.instance.play("047");
            var _local_2:ColorItem = (_arg_1.currentTarget as ColorItem);
            this.selectedSkin = _local_2.getColor();
        }

        private function __colorEditClick(_arg_1:Event):void
        {
            SoundManager.instance.play("047");
            this.editColor(this.selectedColor);
        }

        private function __skinEditClick(_arg_1:Event):void
        {
            SoundManager.instance.play("047");
            this.editSkin(this.selectedSkin);
        }

        protected function __restoreColorBtnClick(_arg_1:MouseEvent):void
        {
            if (this.selectedType == 1)
            {
                this.resetColor();
            }
            else
            {
                this.resetSkin();
            };
            this._restoreColorBtn.enable = false;
            SoundManager.instance.play("008");
            dispatchEvent(new Event(REDUCTIVE_COLOR));
        }

        public function dispose():void
        {
            this._colorBtn.removeEventListener(MouseEvent.CLICK, this.__colorEditClick);
            this._textureBtn.removeEventListener(MouseEvent.CLICK, this.__skinEditClick);
            this._restoreColorBtn.removeEventListener(MouseEvent.CLICK, this.__restoreColorBtnClick);
            this._colorBtn = null;
            this._textureBtn = null;
            this._restoreColorBtn = null;
            this._colorPanelBgI = null;
            var _local_1:int;
            while (_local_1 < this._colors.length)
            {
                this._colorsArr[_local_1].removeEventListener(MouseEvent.MOUSE_DOWN, this.__colorItemClick);
                this._colorsArr[_local_1].dispose();
                this._colorsArr[_local_1] = null;
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._skinsArr.length)
            {
                this._skinsArr[_local_2].removeEventListener(MouseEvent.MOUSE_DOWN, this.__skinItemClick);
                this._skinsArr[_local_2].dispose();
                this._skinsArr[_local_2] = null;
                _local_2++;
            };
            if (this._colorlist)
            {
                if (this._colorlist.parent)
                {
                    this._colorlist.parent.removeChild(this._colorlist);
                };
                this._colorlist.disposeAllChildren();
            };
            this._colorlist = null;
            if (this._skincolorlist)
            {
                if (this._skincolorlist.parent)
                {
                    this._skincolorlist.parent.removeChild(this._skincolorlist);
                };
                this._skincolorlist.disposeAllChildren();
            };
            this._skincolorlist = null;
            this._colors = null;
            this._skins = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view

