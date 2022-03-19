// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.view.ChangeColorLeftView

package changeColor.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.DisplayObject;
    import ddt.view.character.ICharacter;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import ddt.view.ColorEditor;
    import changeColor.ChangeColorModel;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import bagAndInfo.cell.BagCell;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.character.CharactoryFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.utils.StringHelper;
    import ddt.data.EquipType;

    public class ChangeColorLeftView extends Sprite implements Disposeable 
    {

        private var _charaterBack:Bitmap;
        private var _colorBack:Scale9CornerImage;
        private var _title:DisplayObject;
        private var _charater:ICharacter;
        private var _hideHat:SelectedCheckButton;
        private var _hideGlass:SelectedCheckButton;
        private var _hideSuit:SelectedCheckButton;
        private var _hideWing:SelectedCheckButton;
        private var _cell:ColorEditCell;
        private var _cellBg:Scale9CornerImage;
        private var _colorEditor:ColorEditor;
        private var _model:ChangeColorModel;
        private var _checkBg:MovieImage;
        private var _itemChanged:Boolean;


        public function dispose():void
        {
            this.removeEvents();
            ObjectUtils.disposeAllChildren(this);
            this._charaterBack = null;
            this._colorBack = null;
            this._cell = null;
            this._charater = null;
            this._colorEditor = null;
            this._model = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function set model(_arg_1:ChangeColorModel):void
        {
            this._model = _arg_1;
            this.dataUpdate();
        }

        public function reset():void
        {
            if (this._model.currentItem == null)
            {
                return;
            };
            this.restoreItem();
            this.restoreCharacter();
            this._model.changed = false;
            this._model.currentItem = null;
        }

        public function setCurrentItem(_arg_1:BagCell):void
        {
            SoundManager.instance.play("008");
            if (((this._cell.bagCell == null) && (!(_arg_1.info == null))))
            {
                this._cell.bagCell = _arg_1;
                _arg_1.locked = true;
            }
            else
            {
                this._model.initColor = null;
                this._model.initSkinColor = null;
                this._cell.bagCell.locked = false;
                this._cell.bagCell = _arg_1;
                _arg_1.locked = true;
            };
            this.updateColorPanel();
        }

        private function __cellChangedHandler(_arg_1:Event):void
        {
            if ((((_arg_1.target as BagCell).info) && (this._model.currentItem == null)))
            {
                this._model.currentItem = this._cell.bagCell.itemInfo;
                this.savaItemInfo();
                this.updateCharator();
            }
            else
            {
                if ((_arg_1.target as BagCell).info == null)
                {
                    this.reset();
                };
            };
            this.updateColorPanel();
        }

        private function __hideGalssChange(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.self.setGlassHide(this._hideGlass.selected);
        }

        private function __hideHatChange(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.self.setHatHide(this._hideHat.selected);
        }

        private function __hideSuitChange(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.self.setSuiteHide(this._hideSuit.selected);
        }

        private function __hideWingChange(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.self.wingHide = this._hideWing.selected;
        }

        private function __setColor(_arg_1:Event):void
        {
            if (this._model.currentItem)
            {
                if (this._colorEditor.selectedType == 2)
                {
                    this.setItemSkin(this._model.currentItem, this._colorEditor.selectedSkin.toString());
                }
                else
                {
                    this.setItemColor(this._model.currentItem, this._colorEditor.selectedColor.toString());
                };
                this._model.changed = true;
            };
        }

        private function dataUpdate():void
        {
            this.initView();
            this.initEvents();
        }

        private function initEvents():void
        {
            this._cell.addEventListener(Event.CHANGE, this.__cellChangedHandler);
            this._colorEditor.addEventListener(Event.CHANGE, this.__setColor);
            this._colorEditor.addEventListener(ColorEditor.REDUCTIVE_COLOR, this.__reductiveColor);
            this._hideHat.addEventListener(MouseEvent.CLICK, this.__hideHatChange);
            this._hideGlass.addEventListener(MouseEvent.CLICK, this.__hideGalssChange);
            this._hideSuit.addEventListener(MouseEvent.CLICK, this.__hideSuitChange);
            this._hideWing.addEventListener(MouseEvent.CLICK, this.__hideWingChange);
        }

        private function initView():void
        {
            var _local_1:Rectangle;
            this._title = ComponentFactory.Instance.creatBitmap("asset.changeColor.title");
            addChild(this._title);
            this._charaterBack = ComponentFactory.Instance.creatBitmap("changeColor.leftViewBg");
            addChild(this._charaterBack);
            this._colorBack = ComponentFactory.Instance.creatComponentByStylename("changeColor.leftViewBgI");
            addChild(this._colorBack);
            this._checkBg = ComponentFactory.Instance.creatComponentByStylename("changeColor.checkBg");
            addChild(this._checkBg);
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.leftViewBgImgRec");
            this._charater = CharactoryFactory.createCharacter(this._model.self);
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.charaterRec");
            ObjectUtils.copyPropertyByRectangle((this._charater as DisplayObject), _local_1);
            this._charater.show(false, -1);
            this._charater.showGun = false;
            addChild((this._charater as DisplayObject));
            this._cellBg = ComponentFactory.Instance.creatComponentByStylename("ColorEditCell.Bg");
            addChild(this._cellBg);
            var _local_2:Sprite = new Sprite();
            _local_2.graphics.beginFill(0, 0);
            _local_2.graphics.drawRect(0, 0, 90, 90);
            _local_2.graphics.endFill();
            this._cell = new ColorEditCell(_local_2);
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.colorEditCellRec");
            ObjectUtils.copyPropertyByRectangle((this._cell as DisplayObject), _local_1);
            addChild(this._cell);
            this._colorEditor = ComponentFactory.Instance.creatCustomObject("changeColor.ColorEdit");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.colorEditorRec");
            ObjectUtils.copyPropertyByRectangle((this._colorEditor as DisplayObject), _local_1);
            addChild(this._colorEditor);
            this._hideHat = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.hideHatRec");
            ObjectUtils.copyPropertyByRectangle((this._hideHat as DisplayObject), _local_1);
            this._hideHat.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
            this._hideHat.selected = this._model.self.getHatHide();
            addChild(this._hideHat);
            this._hideGlass = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.hideGlassRec");
            ObjectUtils.copyPropertyByRectangle((this._hideGlass as DisplayObject), _local_1);
            this._hideGlass.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
            this._hideGlass.selected = this._model.self.getGlassHide();
            addChild(this._hideGlass);
            this._hideSuit = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.hideSuitRec");
            ObjectUtils.copyPropertyByRectangle((this._hideSuit as DisplayObject), _local_1);
            this._hideSuit.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
            this._hideSuit.selected = this._model.self.getSuitesHide();
            addChild(this._hideSuit);
            this._hideWing = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.hideWingRec");
            ObjectUtils.copyPropertyByRectangle((this._hideWing as DisplayObject), _local_1);
            this._hideWing.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
            this._hideWing.selected = this._model.self.wingHide;
            addChild(this._hideWing);
            this.updateColorPanel();
        }

        private function removeEvents():void
        {
            this._cell.removeEventListener(Event.CHANGE, this.__cellChangedHandler);
            this._colorEditor.removeEventListener(Event.CHANGE, this.__setColor);
            this._colorEditor.removeEventListener(ColorEditor.REDUCTIVE_COLOR, this.__reductiveColor);
        }

        private function restoreCharacter():void
        {
            this._model.self.setPartStyle(this._model.currentItem, ((this._model.self.Sex) ? 1 : 2), PlayerManager.Instance.Self.getPartStyle(this._model.currentItem.CategoryID), PlayerManager.Instance.Self.getPartColor(this._model.currentItem.CategoryID), true);
            this._model.self.setPartColor(this._model.currentItem.CategoryID, PlayerManager.Instance.Self.getPartColor(this._model.currentItem.CategoryID));
            this._model.self.setSkinColor(PlayerManager.Instance.Self.Skin);
        }

        private function restoreItem():void
        {
            this._model.restoreItem();
        }

        private function savaItemInfo():void
        {
            this._model.savaItemInfo();
        }

        private function setItemColor(_arg_1:InventoryItemInfo, _arg_2:String):void
        {
            if (_arg_1.Color == "||")
            {
                _arg_1.Color = "";
            };
            var _local_3:Array = _arg_1.Color.split("|");
            _local_3[(this._cell.editLayer - 1)] = String(_arg_2);
            var _local_4:String = _local_3.join("|").replace(/\|$/, "");
            _arg_1.Color = _local_4;
            this._cell.setColor(_local_4);
            this._model.self.setPartColor(this._model.currentItem.CategoryID, _local_4);
            this._model.self.setSkinColor(this._model.self.getSkinColor());
        }

        private function setItemSkin(_arg_1:InventoryItemInfo, _arg_2:String):void
        {
            var _local_3:Array = _arg_1.Color.split("|");
            _local_3[1] = _arg_2;
            var _local_4:String = _local_3.join("|");
            _arg_1.Skin = _arg_2;
            this._model.self.setSkinColor(_arg_2);
        }

        public function setInitColor():void
        {
            this._model.self.setPartColor(this._model.currentItem.CategoryID, this._model.initColor);
            this._cell.itemInfo.Color = this._model.initColor;
        }

        public function setInitSkinColor():void
        {
            this._model.self.setSkinColor(this._model.initSkinColor);
            this._cell.itemInfo.Skin = this._model.initSkinColor;
        }

        private function checkColorChanged(_arg_1:String, _arg_2:String):Boolean
        {
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_3:Array = _arg_1.split("|");
            var _local_4:Array = _arg_2.split("|");
            var _local_5:int = Math.max(_local_3.length, _local_4.length);
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_7 = ((!(StringHelper.isNullOrEmpty(_local_3[_local_6]))) && (!(_local_3[_local_6] == "undefined")));
                _local_8 = ((!(StringHelper.isNullOrEmpty(_local_4[_local_6]))) && (!(_local_4[_local_6] == "undefined")));
                if ((((_local_7) || (_local_8)) && (!(_local_3[_local_6] == _local_4[_local_6]))))
                {
                    return (true);
                };
                _local_6++;
            };
            return (false);
        }

        protected function __reductiveColor(_arg_1:Event):void
        {
            var _local_2:Boolean;
            var _local_3:Boolean;
            if (this._colorEditor.selectedType == 1)
            {
                this.setItemColor(this._model.currentItem, "");
            }
            else
            {
                this.setItemSkin(this._model.currentItem, "");
            };
            if (this._cell.info)
            {
                _local_2 = this.checkColorChanged(this._model.initColor, this._cell.itemInfo.Color);
                _local_3 = this.checkColorChanged(this._model.initSkinColor, this._cell.itemInfo.Skin);
                if (((_local_2) || (_local_3)))
                {
                    this._model.changed = true;
                }
                else
                {
                    this._model.changed = false;
                };
            }
            else
            {
                this._model.changed = false;
            };
        }

        private function updateCharator():void
        {
            this._model.self.setPartStyle(this._model.currentItem, this._model.currentItem.NeedSex, this._model.currentItem.TemplateID, this._model.currentItem.Color);
            if (((this._model.currentItem.CategoryID == EquipType.FACE) || (!(this._model.currentItem.Skin == ""))))
            {
                this._model.self.setSkinColor(this._cell.bagCell.itemInfo.Skin);
            }
            else
            {
                this._model.self.setSkinColor(this._model.self.getSkinColor());
            };
        }

        private function updateColorPanel():void
        {
            var _local_1:Array;
            if (this._cell.info == null)
            {
                this._colorEditor.skinEditable = false;
                this._colorEditor.colorEditable = false;
            }
            else
            {
                this._colorEditor.reset();
                _local_1 = this._cell.itemInfo.Color.split("|");
                this._colorEditor.colorRestorable = (((_local_1.length > (this._cell.editLayer - 1)) && (!(StringHelper.isNullOrEmpty(_local_1[(this._cell.editLayer - 1)])))) && (!(_local_1[(this._cell.editLayer - 1)] == "undefined")));
                this._colorEditor.skinRestorable = ((!(StringHelper.isNullOrEmpty(this._cell.itemInfo.Skin))) && (!(this._cell.itemInfo.Skin == "undefined")));
                this._itemChanged = ((this._colorEditor.colorRestorable) || (this._colorEditor.skinRestorable));
                if (this._cell.info.CategoryID == EquipType.FACE)
                {
                    if (EquipType.isEditable(this._cell.info))
                    {
                        this._colorEditor.colorEditable = true;
                    };
                    this._colorEditor.skinEditable = true;
                }
                else
                {
                    this._colorEditor.colorEditable = true;
                };
                this._colorEditor.editColor();
                if ((!(this._model.initColor)))
                {
                    this._model.initColor = this._cell.itemInfo.Color;
                };
                if ((!(this._model.initSkinColor)))
                {
                    this._model.initSkinColor = this._cell.itemInfo.Skin;
                };
                if (this._colorEditor.selectedType == 2)
                {
                    this._colorEditor.editSkin();
                };
            };
            if (this._colorEditor.skinEditable == false)
            {
                this._colorEditor.selectedType = 1;
            };
            if (((!(this._colorEditor.colorEditable)) && (this._colorEditor.skinEditable)))
            {
                this._colorEditor.selectedType = 2;
            };
        }


    }
}//package changeColor.view

