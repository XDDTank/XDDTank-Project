// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.LaterEquipmentView

package store.view.strength
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.view.SimpleItem;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.image.Image;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.tips.GoodTipInfo;
    import ddt.data.goods.ShopItemInfo;
    import ddt.utils.PositionUtils;
    import flash.text.TextFormat;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.QualityType;
    import ddt.data.EquipType;
    import ddt.utils.StaticFormula;
    import ddt.manager.LanguageMgr;
    import ddt.view.tips.GoodTip;
    import road7th.utils.StringHelper;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import road7th.utils.DateUtils;
    import ddt.manager.TimeManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class LaterEquipmentView extends Component 
    {

        private var _strengthenLevelImage:MovieImage;
        private var _fusionLevelImage:MovieImage;
        private var _boundImage:ScaleFrameImage;
        private var _nameTxt:FilterFrameText;
        private var _qualityItem:SimpleItem;
        private var _typeItem:SimpleItem;
        private var _mainPropertyItem:SimpleItem;
        private var _armAngleItem:SimpleItem;
        private var _otherHp:SimpleItem;
        private var _necklaceItem:FilterFrameText;
        private var _attackTxt:FilterFrameText;
        private var _defenseTxt:FilterFrameText;
        private var _agilityTxt:FilterFrameText;
        private var _luckTxt:FilterFrameText;
        private var _needLevelTxt:FilterFrameText;
        private var _needSexTxt:FilterFrameText;
        private var _holes:Vector.<FilterFrameText> = new Vector.<FilterFrameText>();
        private var _upgradeType:FilterFrameText;
        private var _descriptionTxt:FilterFrameText;
        private var _bindTypeTxt:FilterFrameText;
        private var _remainTimeTxt:FilterFrameText;
        private var _goldRemainTimeTxt:FilterFrameText;
        private var _fightPropConsumeTxt:FilterFrameText;
        private var _boxTimeTxt:FilterFrameText;
        private var _limitGradeTxt:FilterFrameText;
        private var _info:ItemTemplateInfo;
        private var _bindImageOriginalPos:Point;
        private var _maxWidth:int;
        private var _minWidth:int = 196;
        private var _isArmed:Boolean;
        private var _displayList:Vector.<DisplayObject>;
        private var _displayIdx:int;
        private var _lines:Vector.<Image>;
        private var _lineIdx:int;
        private var _isReAdd:Boolean;
        private var _remainTimeBg:Bitmap;
        private var _tipbackgound:MutipleImage;
        private var _rightArrows:Bitmap;


        override protected function init():void
        {
            this._lines = new Vector.<Image>();
            this._displayList = new Vector.<DisplayObject>();
            this._rightArrows = ComponentFactory.Instance.creatBitmap("asset.ddtstore.rightArrows");
            this._tipbackgound = ComponentFactory.Instance.creat("ddtstore.strengthTips.strengthenImageBG");
            this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
            this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
            this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
            this._bindImageOriginalPos = new Point(this._boundImage.x, this._boundImage.y);
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
            this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
            this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
            this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
            this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
            this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
            this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._holes = new Vector.<FilterFrameText>();
            var _local_1:int;
            while (_local_1 < 6)
            {
                this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
                _local_1++;
            };
            this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
            this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
            this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
            this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
            this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            this._limitGradeTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if (_arg_1)
            {
                if ((_arg_1 is GoodTipInfo))
                {
                    _tipData = (_arg_1 as GoodTipInfo);
                    this.showTip(_tipData.itemInfo, _tipData.typeIsSecond);
                }
                else
                {
                    if ((_arg_1 is ShopItemInfo))
                    {
                        _tipData = (_arg_1 as ShopItemInfo);
                        this.showTip(_tipData.TemplateInfo);
                    };
                };
                visible = true;
            }
            else
            {
                _tipData = null;
                visible = false;
            };
        }

        public function showTip(_arg_1:ItemTemplateInfo, _arg_2:Boolean=false):void
        {
            this._displayIdx = 0;
            this._displayList = new Vector.<DisplayObject>();
            this._lineIdx = 0;
            this._isReAdd = false;
            this._maxWidth = 0;
            this._info = _arg_1;
            this.updateView();
        }

        private function updateView():void
        {
            if (this._info == null)
            {
                return;
            };
            this.clear();
            this._isArmed = false;
            this.createItemName();
            this.createQualityItem();
            this.createCategoryItem();
            this.createMainProperty();
            this.seperateLine();
            this.createNecklaceItem();
            this.createProperties();
            this.seperateLine();
            this.createOperationItem();
            this.seperateLine();
            this.createDescript();
            this.createBindType();
            this.createRemainTime();
            this.createGoldRemainTime();
            this.createFightPropConsume();
            this.createBoxTimeItem();
            this.createShopItemLimitGrade((_tipData as ShopItemInfo));
            this.addChildren();
            this.createStrenthLevel();
        }

        private function clear():void
        {
            var _local_1:DisplayObject;
            while (numChildren > 0)
            {
                _local_1 = (getChildAt(0) as DisplayObject);
                if (_local_1.parent)
                {
                    _local_1.parent.removeChild(_local_1);
                };
            };
        }

        override protected function addChildren():void
        {
            var _local_4:DisplayObject;
            var _local_1:int = this._displayList.length;
            var _local_2:Point = new Point(4, 4);
            var _local_3:int = 6;
            var _local_5:int = this._maxWidth;
            var _local_6:int;
            while (_local_6 < _local_1)
            {
                _local_4 = (this._displayList[_local_6] as DisplayObject);
                if (((this._lines.indexOf(_local_4) < 0) && (!(_local_4 == this._descriptionTxt))))
                {
                    _local_5 = Math.max(_local_4.width, _local_5);
                };
                PositionUtils.setPos(_local_4, _local_2);
                addChild(_local_4);
                _local_2.y = ((_local_4.y + _local_4.height) + _local_3);
                _local_6++;
            };
            this._maxWidth = Math.max(this._minWidth, _local_5);
            if (this._descriptionTxt.width != this._maxWidth)
            {
                this._descriptionTxt.width = this._maxWidth;
                this._descriptionTxt.height = (this._descriptionTxt.textHeight + 10);
                this.addChildren();
                return;
            };
            if ((!(this._isReAdd)))
            {
                _local_6 = 0;
                while (_local_6 < this._lines.length)
                {
                    this._lines[_local_6].width = this._maxWidth;
                    if (((((_local_6 + 1) < this._lines.length) && (!(this._lines[(_local_6 + 1)].parent == null))) && (Math.abs((this._lines[(_local_6 + 1)].y - this._lines[_local_6].y)) <= 10)))
                    {
                        this._displayList.splice(this._displayList.indexOf(this._lines[(_local_6 + 1)]), 1);
                        this._lines[(_local_6 + 1)].parent.removeChild(this._lines[(_local_6 + 1)]);
                        this._isReAdd = true;
                    };
                    _local_6++;
                };
                if (this._isReAdd)
                {
                    this.addChildren();
                    return;
                };
            };
            if (this._rightArrows)
            {
                addChildAt(this._rightArrows, 0);
            };
            if (_local_1 > 0)
            {
                this._tipbackgound.y = -5;
                _width = (this._tipbackgound.width = (this._maxWidth + 8));
                _height = (this._tipbackgound.height = ((_local_4.y + _local_4.height) + 18));
            };
            if (this._tipbackgound)
            {
                addChildAt(this._tipbackgound, 0);
            };
            if (this._remainTimeBg.parent)
            {
                this._remainTimeBg.x = (this._remainTimeTxt.x + 2);
                this._remainTimeBg.y = (this._remainTimeTxt.y + 2);
                this._remainTimeBg.parent.addChildAt(this._remainTimeBg, 1);
            };
            if (this._remainTimeBg.parent)
            {
                this._goldRemainTimeTxt.x = (this._remainTimeTxt.x + 2);
                this._goldRemainTimeTxt.y = (this._remainTimeTxt.y + 22);
                this._remainTimeBg.parent.addChildAt(this._goldRemainTimeTxt, 1);
            };
            this._rightArrows.x = (5 - this._rightArrows.width);
            this._rightArrows.y = ((this.height - this._rightArrows.height) / 2);
        }

        private function createItemName():void
        {
            var _local_3:TextFormat;
            this._nameTxt.text = String(this._info.Name);
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (((_local_1) && (_local_1.StrengthenLevel > 0)))
            {
                this._nameTxt.text = (this._nameTxt.text + (("(+" + (this._info as InventoryItemInfo).StrengthenLevel) + ")"));
            };
            var _local_2:int = this._nameTxt.text.indexOf("+");
            if (_local_2 > 0)
            {
                _local_3 = ComponentFactory.Instance.model.getSet("core.goodTip.ItemNameNumTxtFormat");
                this._nameTxt.setTextFormat(_local_3, _local_2, (_local_2 + 1));
            };
            this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
            var _local_4:* = this._displayIdx++;
            this._displayList[_local_4] = this._nameTxt;
        }

        private function createQualityItem():void
        {
            var _local_1:FilterFrameText = (this._qualityItem.foreItems[0] as FilterFrameText);
            _local_1.text = QualityType.QUALITY_STRING[this._info.Quality];
            _local_1.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
            var _local_2:* = this._displayIdx++;
            this._displayList[_local_2] = this._qualityItem;
        }

        private function createCategoryItem():void
        {
            var _local_1:FilterFrameText = (this._typeItem.foreItems[0] as FilterFrameText);
            var _local_2:Array = EquipType.PARTNAME;
            _local_1.text = ((!(EquipType.PARTNAME[this._info.CategoryID])) ? "" : EquipType.PARTNAME[this._info.CategoryID]);
            var _local_3:* = this._displayIdx++;
            this._displayList[_local_3] = this._typeItem;
        }

        private function createMainProperty():void
        {
            var _local_1:String = "";
            var _local_2:FilterFrameText = (this._mainPropertyItem.foreItems[0] as FilterFrameText);
            var _local_3:ScaleFrameImage = (this._mainPropertyItem.backItem as ScaleFrameImage);
            var _local_4:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (EquipType.isArm(this._info))
            {
                if (((_local_4) && (_local_4.StrengthenLevel > 0)))
                {
                    _local_1 = (("(+" + StaticFormula.getHertAddition(int(_local_4.Property7), _local_4.StrengthenLevel)) + ")");
                };
                _local_3.setFrame(1);
                _local_2.text = ((" " + this._info.Property7.toString()) + _local_1);
                FilterFrameText(this._armAngleItem.foreItems[0]).text = ((((" " + this._info.Property5) + "°~") + this._info.Property6) + "°");
                var _local_5:* = this._displayIdx++;
                this._displayList[_local_5] = this._mainPropertyItem;
                var _local_6:* = this._displayIdx++;
                this._displayList[_local_6] = this._armAngleItem;
            }
            else
            {
                if (((EquipType.isHead(this._info)) || (EquipType.isCloth(this._info))))
                {
                    if (((_local_4) && (_local_4.StrengthenLevel > 0)))
                    {
                        _local_1 = (("(+" + StaticFormula.getDefenseAddition(int(_local_4.Property7), _local_4.StrengthenLevel)) + ")");
                    };
                    _local_3.setFrame(2);
                    _local_2.text = ((" " + this._info.Property7.toString()) + _local_1);
                    _local_5 = this._displayIdx++;
                    this._displayList[_local_5] = this._mainPropertyItem;
                    if (((_local_4) && (_local_4.StrengthenLevel == 13)))
                    {
                        FilterFrameText(this._otherHp.foreItems[0]).text = _local_4.Boold.toString();
                        _local_6 = this._displayIdx++;
                        this._displayList[_local_6] = this._otherHp;
                    };
                }
                else
                {
                    if (StaticFormula.isDeputyWeapon(this._info))
                    {
                        if (this._info.Property3 == "32")
                        {
                            if (((_local_4) && (_local_4.StrengthenLevel > 0)))
                            {
                                _local_1 = (("(+" + StaticFormula.getRecoverHPAddition(int(_local_4.Property7), _local_4.StrengthenLevel)) + ")");
                            };
                            _local_3.setFrame(3);
                        }
                        else
                        {
                            if (((_local_4) && (_local_4.StrengthenLevel > 0)))
                            {
                                _local_1 = (("(+" + StaticFormula.getDefenseAddition(int(_local_4.Property7), _local_4.StrengthenLevel)) + ")");
                            };
                            _local_3.setFrame(4);
                        };
                        _local_2.text = ((" " + this._info.Property7.toString()) + _local_1);
                        _local_5 = this._displayIdx++;
                        this._displayList[_local_5] = this._mainPropertyItem;
                    };
                };
            };
        }

        private function createNecklaceItem():void
        {
            if (this._info.CategoryID == 14)
            {
                this._necklaceItem.text = ((((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance")) + this._info.Property1) + "%");
                this._necklaceItem.textColor = GoodTip.ITEM_NECKLACE_COLOR;
                var _local_1:* = this._displayIdx++;
                this._displayList[_local_1] = this._necklaceItem;
            }
            else
            {
                if (this._info.CategoryID == EquipType.HEALSTONE)
                {
                    this._necklaceItem.text = (((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply")) + this._info.Property2);
                    this._necklaceItem.textColor = GoodTip.ITEM_NECKLACE_COLOR;
                    _local_1 = this._displayIdx++;
                    this._displayList[_local_1] = this._necklaceItem;
                };
            };
        }

        private function setPurpleHtmlTxt(_arg_1:String, _arg_2:int, _arg_3:String):String
        {
            return (LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.setPurpleHtmlTxt", _arg_1, _arg_2, _arg_3));
        }

        private function createProperties():void
        {
            var _local_5:InventoryItemInfo;
            var _local_1:String = "";
            var _local_2:String = "";
            var _local_3:String = "";
            var _local_4:String = "";
            if ((this._info is InventoryItemInfo))
            {
                _local_5 = (this._info as InventoryItemInfo);
                if (_local_5.AttackCompose > 0)
                {
                    _local_1 = (("(+" + String(_local_5.AttackCompose)) + ")");
                };
                if (_local_5.DefendCompose > 0)
                {
                    _local_2 = (("(+" + String(_local_5.DefendCompose)) + ")");
                };
                if (_local_5.AgilityCompose > 0)
                {
                    _local_3 = (("(+" + String(_local_5.AgilityCompose)) + ")");
                };
                if (_local_5.LuckCompose > 0)
                {
                    _local_4 = (("(+" + String(_local_5.LuckCompose)) + ")");
                };
            };
            if (this._info.Attack != 0)
            {
                this._attackTxt.htmlText = this.setPurpleHtmlTxt((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":"), this._info.Attack, _local_1);
                var _local_6:* = this._displayIdx++;
                this._displayList[_local_6] = this._attackTxt;
            };
            if (this._info.Defence != 0)
            {
                this._defenseTxt.htmlText = this.setPurpleHtmlTxt((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":"), this._info.Defence, _local_2);
                _local_6 = this._displayIdx++;
                this._displayList[_local_6] = this._defenseTxt;
            };
            if (this._info.Agility != 0)
            {
                this._agilityTxt.htmlText = this.setPurpleHtmlTxt((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":"), this._info.Agility, _local_3);
                _local_6 = this._displayIdx++;
                this._displayList[_local_6] = this._agilityTxt;
            };
            if (this._info.Luck != 0)
            {
                this._luckTxt.htmlText = this.setPurpleHtmlTxt((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":"), this._info.Luck, _local_4);
                _local_6 = this._displayIdx++;
                this._displayList[_local_6] = this._luckTxt;
            };
        }

        private function createHoleItem():void
        {
            var _local_1:Array;
            var _local_2:Array;
            var _local_3:InventoryItemInfo;
            var _local_4:int;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:FilterFrameText;
            var _local_8:int;
            if ((!(StringHelper.isNullOrEmpty(this._info.Hole))))
            {
                _local_1 = [];
                _local_2 = this._info.Hole.split("|");
                _local_3 = (this._info as InventoryItemInfo);
                if ((((_local_2.length > 0) && (!(String(_local_2[0]) == ""))) && (!(_local_3 == null))))
                {
                    _local_4 = 0;
                    while (_local_4 < _local_2.length)
                    {
                        _local_5 = String(_local_2[_local_4]);
                        _local_6 = _local_5.split(",");
                        if (_local_4 < 4)
                        {
                            if ((((int(_local_6[0]) > 0) && ((int(_local_6[0]) - _local_3.StrengthenLevel) <= 3)) || (this.getHole(_local_3, (_local_4 + 1)) >= 0)))
                            {
                                _local_8 = int(_local_6[0]);
                                _local_7 = this.createSingleHole(_local_3, _local_4, _local_8, _local_6[1]);
                                var _local_9:* = this._displayIdx++;
                                this._displayList[_local_9] = _local_7;
                            };
                        }
                        else
                        {
                            if (((_local_3[(("Hole" + (_local_4 + 1)) + "Level")] >= 1) || (_local_3[("Hole" + (_local_4 + 1))] > 0)))
                            {
                                _local_7 = this.createSingleHole(_local_3, _local_4, int.MAX_VALUE, _local_6[1]);
                                _local_9 = this._displayIdx++;
                                this._displayList[_local_9] = _local_7;
                            };
                        };
                        _local_4++;
                    };
                };
            };
        }

        private function createSingleHole(_arg_1:InventoryItemInfo, _arg_2:int, _arg_3:int, _arg_4:int):FilterFrameText
        {
            var _local_6:ItemTemplateInfo;
            var _local_8:int;
            var _local_5:FilterFrameText = this._holes[_arg_2];
            var _local_7:int = this.getHole(_arg_1, (_arg_2 + 1));
            if (_arg_1.StrengthenLevel >= _arg_3)
            {
                if (_local_7 <= 0)
                {
                    _local_5.text = ((this.getHoleType(_arg_4) + ":") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeenable"));
                    _local_5.textColor = GoodTip.ITEM_HOLES_COLOR;
                }
                else
                {
                    _local_6 = ItemManager.Instance.getTemplateById(_local_7);
                    if (_local_6)
                    {
                        _local_5.text = _local_6.Data;
                        _local_5.textColor = GoodTip.ITEM_HOLE_RESERVE_COLOR;
                    };
                };
            }
            else
            {
                if (_arg_2 >= 4)
                {
                    _local_8 = _arg_1[(("Hole" + (_arg_2 + 1)) + "Level")];
                    if (_local_7 > 0)
                    {
                        _local_6 = ItemManager.Instance.getTemplateById(_local_7);
                        _local_5.text = (_local_6.Data + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv", _arg_1[(("Hole" + (_arg_2 + 1)) + "Level")]));
                        if (Math.floor(((_local_6.Level + 1) >> 1)) <= _local_8)
                        {
                            _local_5.textColor = GoodTip.ITEM_HOLE_RESERVE_COLOR;
                        }
                        else
                        {
                            _local_5.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
                        };
                    }
                    else
                    {
                        _local_5.text = (this.getHoleType(_arg_4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv", _arg_1[(("Hole" + (_arg_2 + 1)) + "Level")])));
                        _local_5.textColor = GoodTip.ITEM_HOLES_COLOR;
                    };
                }
                else
                {
                    if (_local_7 <= 0)
                    {
                        _local_5.text = (this.getHoleType(_arg_4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"), _arg_3.toString()));
                        _local_5.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
                    }
                    else
                    {
                        _local_6 = ItemManager.Instance.getTemplateById(_local_7);
                        if (_local_6)
                        {
                            _local_5.text = (_local_6.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"), _arg_3.toString()));
                            _local_5.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
                        };
                    };
                };
            };
            return (_local_5);
        }

        public function getHole(_arg_1:InventoryItemInfo, _arg_2:int):int
        {
            return (int(_arg_1[("Hole" + _arg_2.toString())]));
        }

        private function getHoleType(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 1:
                    return (LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.trianglehole"));
                case 2:
                    return (LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recthole"));
                case 3:
                    return (LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.ciclehole"));
            };
            return (LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.unknowhole"));
        }

        private function createOperationItem():void
        {
            var _local_2:uint;
            if (this._info.NeedLevel > 1)
            {
                if (PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
                {
                    _local_2 = GoodTip.ITEM_NEED_LEVEL_COLOR;
                }
                else
                {
                    _local_2 = GoodTip.ITEM_NEED_LEVEL_FAILED_COLOR;
                };
                this._needLevelTxt.text = ((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":") + String(this._info.NeedLevel));
                this._needLevelTxt.textColor = _local_2;
                var _local_3:* = this._displayIdx++;
                this._displayList[_local_3] = this._needLevelTxt;
            };
            if (this._info.NeedSex == 1)
            {
                this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
                this._needSexTxt.textColor = ((PlayerManager.Instance.Self.Sex) ? GoodTip.ITEM_NEED_SEX_COLOR : GoodTip.ITEM_NEED_SEX_FAILED_COLOR);
                _local_3 = this._displayIdx++;
                this._displayList[_local_3] = this._needSexTxt;
            }
            else
            {
                if (this._info.NeedSex == 2)
                {
                    this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
                    this._needSexTxt.textColor = ((PlayerManager.Instance.Self.Sex) ? GoodTip.ITEM_NEED_SEX_FAILED_COLOR : GoodTip.ITEM_NEED_SEX_COLOR);
                    _local_3 = this._displayIdx++;
                    this._displayList[_local_3] = this._needSexTxt;
                };
            };
            var _local_1:String = "";
            if (((this._info.CanStrengthen) && (this._info.CanCompose)))
            {
                _local_1 = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
                this._upgradeType.text = _local_1;
                this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
                _local_3 = this._displayIdx++;
                this._displayList[_local_3] = this._upgradeType;
            }
            else
            {
                if (this._info.CanCompose)
                {
                    _local_1 = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
                    this._upgradeType.text = _local_1;
                    this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
                    _local_3 = this._displayIdx++;
                    this._displayList[_local_3] = this._upgradeType;
                }
                else
                {
                    if (this._info.CanStrengthen)
                    {
                        _local_1 = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
                        this._upgradeType.text = _local_1;
                        this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
                        _local_3 = this._displayIdx++;
                        this._displayList[_local_3] = this._upgradeType;
                    };
                };
            };
        }

        private function createDescript():void
        {
            if (this._info.Description == "")
            {
                return;
            };
            this._descriptionTxt.text = this._info.Description;
            this._descriptionTxt.height = (this._descriptionTxt.textHeight + 10);
            var _local_1:* = this._displayIdx++;
            this._displayList[_local_1] = this._descriptionTxt;
        }

        private function createShopItemLimitGrade(_arg_1:ShopItemInfo):void
        {
            if (((_arg_1) && (_arg_1.LimitGrade > PlayerManager.Instance.Self.Grade)))
            {
                this._limitGradeTxt.text = LanguageMgr.GetTranslation("ddt.shop.LimitGradeBuy", _arg_1.LimitGrade);
                var _local_2:* = this._displayIdx++;
                this._displayList[_local_2] = this._limitGradeTxt;
            };
        }

        private function ShowBound(_arg_1:InventoryItemInfo):Boolean
        {
            return (((!(_arg_1.CategoryID == EquipType.SEED)) && (!(_arg_1.CategoryID == EquipType.MANURE))) && (!(_arg_1.CategoryID == EquipType.VEGETABLE)));
        }

        private function createBindType():void
        {
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (((_local_1) && (this.ShowBound(_local_1))))
            {
                this._boundImage.setFrame(((_local_1.IsBinds) ? GoodTip.BOUND : GoodTip.UNBOUND));
                PositionUtils.setPos(this._boundImage, this._bindImageOriginalPos);
                addChild(this._boundImage);
                if ((!(_local_1.IsBinds)))
                {
                    if (_local_1.BindType == 3)
                    {
                        this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                        this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                        var _local_2:* = this._displayIdx++;
                        this._displayList[_local_2] = this._bindTypeTxt;
                    }
                    else
                    {
                        if (this._info.BindType == 2)
                        {
                            this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                            this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                            _local_2 = this._displayIdx++;
                            this._displayList[_local_2] = this._bindTypeTxt;
                        }
                        else
                        {
                            if (this._info.BindType == 4)
                            {
                                if (this._boundImage.parent)
                                {
                                    this._boundImage.parent.removeChild(this._boundImage);
                                };
                            };
                        };
                    };
                };
            }
            else
            {
                if (this._boundImage.parent)
                {
                    this._boundImage.parent.removeChild(this._boundImage);
                };
            };
        }

        private function createRemainTime():void
        {
            var _local_1:Number;
            var _local_2:InventoryItemInfo;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:String;
            var _local_6:Number;
            if (this._remainTimeBg.parent)
            {
                this._remainTimeBg.parent.removeChild(this._remainTimeBg);
            };
            if ((this._info is InventoryItemInfo))
            {
                _local_2 = (this._info as InventoryItemInfo);
                _local_3 = _local_2.getRemainDate();
                _local_4 = _local_2.getColorValidDate();
                _local_5 = ((_local_2.CategoryID == EquipType.ARM) ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "");
                if (((_local_4 > 0) && (!(_local_4 == int.MAX_VALUE))))
                {
                    if (_local_4 >= 1)
                    {
                        this._remainTimeTxt.text = ((((_local_2.IsUsed) ? (LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less")) : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(_local_4)) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day"));
                        this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                        var _local_7:* = this._displayIdx++;
                        this._displayList[_local_7] = this._remainTimeTxt;
                    }
                    else
                    {
                        _local_6 = Math.floor((_local_4 * 24));
                        if (_local_6 < 1)
                        {
                            _local_6 = 1;
                        };
                        this._remainTimeTxt.text = ((((_local_2.IsUsed) ? (LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less")) : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _local_6) + LanguageMgr.GetTranslation("hours"));
                        this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                        _local_7 = this._displayIdx++;
                        this._displayList[_local_7] = this._remainTimeTxt;
                    };
                };
                if (_local_3 == int.MAX_VALUE)
                {
                    this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
                    this._remainTimeTxt.textColor = GoodTip.ITEM_ETERNAL_COLOR;
                    _local_7 = this._displayIdx++;
                    this._displayList[_local_7] = this._remainTimeTxt;
                }
                else
                {
                    if (_local_3 > 0)
                    {
                        if (_local_3 >= 1)
                        {
                            _local_1 = Math.ceil(_local_3);
                            this._remainTimeTxt.text = ((((_local_2.IsUsed) ? (_local_5 + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less")) : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _local_1) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day"));
                            this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                            _local_7 = this._displayIdx++;
                            this._displayList[_local_7] = this._remainTimeTxt;
                        }
                        else
                        {
                            _local_1 = Math.floor((_local_3 * 24));
                            _local_1 = ((_local_1 < 1) ? 1 : _local_1);
                            this._remainTimeTxt.text = ((((_local_2.IsUsed) ? (_local_5 + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less")) : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _local_1) + LanguageMgr.GetTranslation("hours"));
                            this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                            _local_7 = this._displayIdx++;
                            this._displayList[_local_7] = this._remainTimeTxt;
                        };
                        addChild(this._remainTimeBg);
                    }
                    else
                    {
                        if ((!(isNaN(_local_3))))
                        {
                            this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
                            this._remainTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
                            _local_7 = this._displayIdx++;
                            this._displayList[_local_7] = this._remainTimeTxt;
                        };
                    };
                };
            };
        }

        private function createGoldRemainTime():void
        {
            var _local_1:Number;
            var _local_2:InventoryItemInfo;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:String;
            if (this._remainTimeBg.parent)
            {
                this._remainTimeBg.parent.removeChild(this._remainTimeBg);
            };
            if ((this._info is InventoryItemInfo))
            {
                _local_2 = (this._info as InventoryItemInfo);
                _local_3 = _local_2.getGoldRemainDate();
                _local_4 = _local_2.goldValidDate;
                _local_5 = _local_2.goldBeginTime;
            };
        }

        private function createFightPropConsume():void
        {
            if (this._info.CategoryID == EquipType.FRIGHTPROP)
            {
                this._fightPropConsumeTxt.text = ((" " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume")) + this._info.Property4);
                this._fightPropConsumeTxt.textColor = GoodTip.ITEM_FIGHT_PROP_CONSUME_COLOR;
                var _local_1:* = this._displayIdx++;
                this._displayList[_local_1] = this._fightPropConsumeTxt;
            };
        }

        private function createBoxTimeItem():void
        {
            var _local_1:Date;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            if (EquipType.isTimeBox(this._info))
            {
                _local_1 = DateUtils.getDateByStr((this._info as InventoryItemInfo).BeginDate);
                _local_2 = int(((int(this._info.Property3) * 60) - ((TimeManager.Instance.Now().getTime() - _local_1.getTime()) / 1000)));
                if (_local_2 > 0)
                {
                    _local_3 = int((_local_2 / 3600));
                    _local_4 = int(((_local_2 % 3600) / 60));
                    _local_4 = ((_local_4 > 0) ? _local_4 : 1);
                    this._boxTimeTxt.text = LanguageMgr.GetTranslation("ddt.userGuild.boxTip", _local_3, _local_4);
                    this._boxTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                    var _local_5:* = this._displayIdx++;
                    this._displayList[_local_5] = this._boxTimeTxt;
                };
            };
        }

        private function createStrenthLevel():void
        {
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (((_local_1) && (_local_1.StrengthenLevel > 0)))
            {
                if (_local_1.isGold)
                {
                    this._strengthenLevelImage.setFrame(16);
                }
                else
                {
                    this._strengthenLevelImage.setFrame(_local_1.StrengthenLevel);
                };
                addChild(this._strengthenLevelImage);
                if (this._boundImage.parent)
                {
                    this._boundImage.x = ((this._strengthenLevelImage.x + (this._strengthenLevelImage.displayWidth / 2)) - (this._boundImage.width / 2));
                    this._boundImage.y = (this._lines[0].y + 4);
                };
                this._maxWidth = Math.max((this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth), this._maxWidth);
                _width = (this._tipbackgound.width = (this._maxWidth + 8));
            };
        }

        private function seperateLine():void
        {
            var _local_1:Image;
            this._lineIdx++;
            if (this._lines.length < this._lineIdx)
            {
                _local_1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
                this._lines.push(_local_1);
            };
            var _local_2:* = this._displayIdx++;
            this._displayList[_local_2] = this._lines[(this._lineIdx - 1)];
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._rightArrows)
            {
                ObjectUtils.disposeObject(this._rightArrows);
            };
            this._rightArrows = null;
            if (this._tipbackgound)
            {
                ObjectUtils.disposeObject(this._tipbackgound);
            };
            this._tipbackgound = null;
            if (this._strengthenLevelImage)
            {
                ObjectUtils.disposeObject(this._strengthenLevelImage);
            };
            this._strengthenLevelImage = null;
            if (this._fusionLevelImage)
            {
                ObjectUtils.disposeObject(this._fusionLevelImage);
            };
            this._fusionLevelImage = null;
            if (this._boundImage)
            {
                ObjectUtils.disposeObject(this._boundImage);
            };
            this._boundImage = null;
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._qualityItem)
            {
                ObjectUtils.disposeObject(this._qualityItem);
            };
            this._qualityItem = null;
            if (this._typeItem)
            {
                ObjectUtils.disposeObject(this._typeItem);
            };
            this._typeItem = null;
            if (this._mainPropertyItem)
            {
                ObjectUtils.disposeObject(this._mainPropertyItem);
            };
            this._mainPropertyItem = null;
            if (this._armAngleItem)
            {
                ObjectUtils.disposeObject(this._armAngleItem);
            };
            this._armAngleItem = null;
            if (this._otherHp)
            {
                ObjectUtils.disposeObject(this._otherHp);
            };
            this._otherHp = null;
            if (this._necklaceItem)
            {
                ObjectUtils.disposeObject(this._necklaceItem);
            };
            this._necklaceItem = null;
            if (this._attackTxt)
            {
                ObjectUtils.disposeObject(this._attackTxt);
            };
            this._attackTxt = null;
            if (this._defenseTxt)
            {
                ObjectUtils.disposeObject(this._defenseTxt);
            };
            this._defenseTxt = null;
            if (this._agilityTxt)
            {
                ObjectUtils.disposeObject(this._agilityTxt);
            };
            this._agilityTxt = null;
            if (this._luckTxt)
            {
                ObjectUtils.disposeObject(this._luckTxt);
            };
            this._luckTxt = null;
            if (this._needLevelTxt)
            {
                ObjectUtils.disposeObject(this._needLevelTxt);
            };
            this._needLevelTxt = null;
            if (this._needSexTxt)
            {
                ObjectUtils.disposeObject(this._needSexTxt);
            };
            this._needSexTxt = null;
            if (this._upgradeType)
            {
                ObjectUtils.disposeObject(this._upgradeType);
            };
            this._upgradeType = null;
            if (this._descriptionTxt)
            {
                ObjectUtils.disposeObject(this._descriptionTxt);
            };
            this._descriptionTxt = null;
            if (this._bindTypeTxt)
            {
                ObjectUtils.disposeObject(this._bindTypeTxt);
            };
            this._bindTypeTxt = null;
            if (this._remainTimeTxt)
            {
                ObjectUtils.disposeObject(this._remainTimeTxt);
            };
            this._remainTimeTxt = null;
            if (this._goldRemainTimeTxt)
            {
                ObjectUtils.disposeObject(this._goldRemainTimeTxt);
            };
            this._goldRemainTimeTxt = null;
            if (this._fightPropConsumeTxt)
            {
                ObjectUtils.disposeObject(this._fightPropConsumeTxt);
            };
            this._fightPropConsumeTxt = null;
            if (this._boxTimeTxt)
            {
                ObjectUtils.disposeObject(this._boxTimeTxt);
            };
            this._boxTimeTxt = null;
            if (this._limitGradeTxt)
            {
                ObjectUtils.disposeObject(this._limitGradeTxt);
            };
            this._limitGradeTxt = null;
            if (this._remainTimeBg)
            {
                ObjectUtils.disposeObject(this._remainTimeBg);
            };
            this._remainTimeBg = null;
            if (this._tipbackgound)
            {
                ObjectUtils.disposeObject(this._tipbackgound);
            };
            this._tipbackgound = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

