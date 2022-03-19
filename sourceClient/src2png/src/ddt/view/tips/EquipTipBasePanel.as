// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.EquipTipBasePanel

package ddt.view.tips
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ShopItemInfo;
    import store.data.RefiningConfigInfo;
    import ddt.data.goods.InventoryItemInfo;
    import store.StoreController;
    import ddt.manager.LanguageMgr;
    import ddt.data.EquipType;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import road7th.utils.DateUtils;
    import ddt.manager.ShopManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class EquipTipBasePanel extends Component 
    {

        public static const THISWIDTH:int = 200;
        public static const MAX_HOLE:int = 4;

        private var _bg:DisplayObject;
        private var _equipName:FilterFrameText;
        private var _StrengthLimit:FilterFrameText;
        private var _equipPosition:FilterFrameText;
        private var _NeedLevel:FilterFrameText;
        private var _MainPropertyTxt:Vector.<FilterFrameText>;
        private var _propVec:Vector.<FilterFrameText>;
        private var _refiningTitleTxt:FilterFrameText;
        private var _refiningTitleDec:FilterFrameText;
        private var _refiningTxtVec:Vector.<FilterFrameText>;
        private var _embedVec:Vector.<EquipTipEmbedItem>;
        private var _DescriptionTxt:FilterFrameText;
        private var _equipScore:FilterFrameText;
        private var _rule3:ScaleBitmapImage;
        private var _rule4:ScaleBitmapImage;
        private var _rule5:ScaleBitmapImage;
        private var _rule6:ScaleBitmapImage;
        private var _info:ItemTemplateInfo;
        private var _EquipInfo:EquipmentTemplateInfo;
        private var _thisHeight:int;
        private var _bindImage:ScaleFrameImage;
        private var _Property:Boolean;
        private var _AngleTxt:FilterFrameText;
        private var _timeRule:ScaleBitmapImage;
        private var _restTimeTxt:FilterFrameText;
        private var _type:int;

        public function EquipTipBasePanel(_arg_1:int=0)
        {
            this._type = _arg_1;
            super();
        }

        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename(((this._type == 0) ? "core.GoodsTipBg" : "EquipsTipPanel.bg"));
            this._rule3 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._rule4 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._rule5 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._rule6 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._equipName = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.name");
            this._equipName.y = (this._equipName.y + ((this._type == 0) ? 0 : 32));
            this._StrengthLimit = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Position");
            this._equipPosition = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Position");
            this._AngleTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.AngleTitle");
            this._NeedLevel = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Position");
            this._MainPropertyTxt = new Vector.<FilterFrameText>(2);
            var _local_1:int;
            while (_local_1 < 2)
            {
                this._MainPropertyTxt[_local_1] = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.MainProperty");
                _local_1++;
            };
            this._propVec = new Vector.<FilterFrameText>(6);
            var _local_2:int;
            while (_local_2 < 6)
            {
                this._propVec[_local_2] = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.basePropTitle");
                _local_2++;
            };
            this._refiningTitleTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.refiningTitleTxt");
            this._refiningTitleDec = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.refiningDecTxt");
            this._refiningTxtVec = new Vector.<FilterFrameText>(5);
            var _local_3:int;
            while (_local_3 < this._refiningTxtVec.length)
            {
                this._refiningTxtVec[_local_3] = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.refiningTxt");
                _local_3++;
            };
            this._embedVec = new Vector.<EquipTipEmbedItem>(MAX_HOLE);
            var _local_4:int;
            while (_local_4 < MAX_HOLE)
            {
                this._embedVec[_local_4] = new EquipTipEmbedItem(_local_4);
                _local_4++;
            };
            this._DescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Description");
            this._equipScore = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Score");
            this._bindImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
            this._timeRule = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._restTimeTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.remainTimeTxt");
            super.init();
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._bg);
            addChild(this._equipName);
            addChild(this._StrengthLimit);
            addChild(this._equipPosition);
            addChild(this._NeedLevel);
            addChild(this._AngleTxt);
            var _local_1:int;
            while (_local_1 < 2)
            {
                addChild(this._MainPropertyTxt[_local_1]);
                _local_1++;
            };
            addChild(this._refiningTitleTxt);
            addChild(this._refiningTitleDec);
            var _local_2:int;
            while (_local_2 < this._refiningTxtVec.length)
            {
                addChild(this._refiningTxtVec[_local_2]);
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < 6)
            {
                addChild(this._propVec[_local_3]);
                _local_3++;
            };
            var _local_4:int;
            while (_local_4 < MAX_HOLE)
            {
                addChild(this._embedVec[_local_4]);
                _local_4++;
            };
            addChild(this._DescriptionTxt);
            addChild(this._equipScore);
            addChild(this._rule3);
            addChild(this._rule4);
            addChild(this._rule5);
            addChild(this._rule6);
            addChild(this._timeRule);
            addChild(this._restTimeTxt);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if ((_arg_1 is ItemTemplateInfo))
            {
                this._info = (_arg_1 as ItemTemplateInfo);
                this.visible = true;
                _tipData = this._info;
                this._EquipInfo = ItemManager.Instance.getEquipTemplateById(this._info.TemplateID);
                this.upView();
            }
            else
            {
                if ((_arg_1 is ShopItemInfo))
                {
                    this._info = ItemManager.Instance.getTemplateById(_arg_1.TemplateID);
                    this.visible = true;
                    _tipData = this._info;
                    this._EquipInfo = ItemManager.Instance.getEquipTemplateById(this._info.TemplateID);
                    this.upView();
                }
                else
                {
                    this.visible = false;
                };
            };
        }

        private function upView():void
        {
            this._thisHeight = 0;
            this.showHeadPart();
            this.showHeadTwoPart();
            this.showMiddlePart();
            this.showMiddleTwoPart();
            this.showRefiningPart();
            this.showEmbedInfo();
            this.showButtomPart();
            this.showRemainTime();
            this.upBackground();
        }

        private function showHeadPart():void
        {
            var _local_2:int;
            var _local_3:RefiningConfigInfo;
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (((_local_1 == null) || (ItemManager.Instance.judgeJewelry(this._info))))
            {
                this._equipName.text = this._info.Name;
            }
            else
            {
                if (_local_1.StrengthenLevel == 0)
                {
                    this._equipName.text = this._info.Name;
                }
                else
                {
                    this._equipName.text = ((this._info.Name + "+") + String(_local_1.StrengthenLevel));
                };
            };
            if (ItemManager.Instance.judgeJewelry(this._info))
            {
                if (_local_1)
                {
                    _local_3 = StoreController.instance.Model.getRefiningConfigByLevel(_local_1.StrengthenLevel);
                    if (_local_3)
                    {
                        _local_2 = (_local_3.Level % 10);
                        this._equipName.text = (this._equipName.text + (("(" + _local_3.Desc) + ")"));
                    }
                    else
                    {
                        this._equipName.text = (this._equipName.text + LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningDefault", 0));
                    };
                }
                else
                {
                    this._equipName.text = (this._equipName.text + LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningDefault", 0));
                };
            };
            if (this._EquipInfo.QualityID == 1)
            {
                this._equipName.textColor = 6277377;
            }
            else
            {
                if (this._EquipInfo.QualityID == 2)
                {
                    this._equipName.textColor = 128510;
                }
                else
                {
                    if (this._EquipInfo.QualityID == 3)
                    {
                        this._equipName.textColor = 13396991;
                    }
                    else
                    {
                        if (this._EquipInfo.QualityID == 4)
                        {
                            this._equipName.textColor = 16729014;
                        }
                        else
                        {
                            if (this._EquipInfo.QualityID == 5)
                            {
                                this._equipName.textColor = 0xFF8000;
                            };
                        };
                    };
                };
            };
            this._thisHeight = ((this._equipName.y + this._equipName.textHeight) + 10);
            this._StrengthLimit.visible = true;
            if (((((this._EquipInfo.TemplateType == 7) || (this._EquipInfo.TemplateType == 8)) || (this._EquipInfo.TemplateType == 9)) || (this._EquipInfo.TemplateType == 10)))
            {
                this._StrengthLimit.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.Synthesis");
            }
            else
            {
                if (this._EquipInfo.TemplateType == EquipType.EMBED_TYPE)
                {
                    this._StrengthLimit.visible = false;
                }
                else
                {
                    if (((EquipType.NoStrengLimitGood(this._info)) || (this._EquipInfo.StrengthLimit <= 0)))
                    {
                        this._StrengthLimit.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.NoStrengLimit");
                    }
                    else
                    {
                        this._StrengthLimit.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.StrengthLimit", this._EquipInfo.StrengthLimit);
                    };
                };
            };
            if (this._StrengthLimit.visible)
            {
                this._StrengthLimit.x = this._equipName.x;
                this._StrengthLimit.y = this._thisHeight;
                this._thisHeight = ((this._StrengthLimit.y + this._StrengthLimit.textHeight) + 18);
            };
        }

        private function showHeadTwoPart():void
        {
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (_local_1)
            {
                this._bindImage.setFrame(((_local_1.IsBinds) ? 1 : 2));
                PositionUtils.setPos(this._bindImage, "ddtcore.equipTip.BindPos");
                this._bindImage.y = (this._bindImage.y + ((this._type == 0) ? 0 : 32));
                addChild(this._bindImage);
            }
            else
            {
                if (this._bindImage.parent)
                {
                    this._bindImage.parent.removeChild(this._bindImage);
                };
            };
            this._equipPosition.visible = true;
            switch (this._EquipInfo.TemplateType)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 13:
                    this._equipPosition.text = LanguageMgr.GetTranslation(("ddt.EquipTipPanel.PositionTxt" + this._EquipInfo.TemplateType));
                    break;
                case 12:
                    this._equipPosition.visible = false;
                    break;
            };
            if (this._equipPosition.visible)
            {
                this._equipPosition.y = this._thisHeight;
                this._thisHeight = ((this._equipPosition.y + this._equipPosition.textHeight) + 8);
            };
            this._NeedLevel.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.NeedLevel", this._info.NeedLevel);
            if (PlayerManager.Instance.Self.Grade < this._info.NeedLevel)
            {
                this._NeedLevel.textColor = 15207950;
            }
            else
            {
                this._NeedLevel.textColor = 0xF5F5F5;
            };
            this._NeedLevel.x = this._equipPosition.x;
            this._NeedLevel.y = this._thisHeight;
            this._thisHeight = (this._NeedLevel.y + this._NeedLevel.textHeight);
        }

        private function showMiddlePart():void
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            var _local_2:Array = new Array();
            var _local_3:EquipmentTemplateInfo = ItemManager.Instance.getEquipPropertyListById(this._EquipInfo.MainProperty1ID);
            var _local_4:EquipmentTemplateInfo = ItemManager.Instance.getEquipPropertyListById(this._EquipInfo.MainProperty2ID);
            if ((((_local_1 == null) || (_local_1.StrengthenLevel == 0)) || (ItemManager.Instance.judgeJewelry(this._info))))
            {
                _local_5 = 0;
                _local_6 = 0;
            }
            else
            {
                _local_5 = ItemManager.Instance.getMinorProperty(this._info, _local_1);
                _local_6 = ItemManager.Instance.getTwoMinorProperty(this._info, _local_1);
            };
            if (this._EquipInfo.MainProperty1ID != 0)
            {
                _local_2.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr", _local_3.PropertyName, this._EquipInfo.MainProperty1Value, ((!(_local_1 == null)) ? ((_local_1.StrengthenLevel > 0) ? ((!(_local_5 == 0)) ? (("(+" + _local_5) + ")") : "") : "") : "")));
            };
            if (this._EquipInfo.MainProperty2ID != 0)
            {
                _local_2.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr", _local_4.PropertyName, this._EquipInfo.MainProperty2Value, ((!(_local_1 == null)) ? ((_local_1.StrengthenLevel > 0) ? ((!(_local_6 == 0)) ? (("(+" + _local_6) + ")") : "") : "") : "")));
            };
            if (_local_2.length == 0)
            {
                this._rule3.y = ((this._NeedLevel.y + this._NeedLevel.textHeight) + 10);
                this._AngleTxt.visible = false;
                this._MainPropertyTxt[0].visible = false;
                this._MainPropertyTxt[1].visible = false;
            }
            else
            {
                _local_7 = 0;
                while (_local_7 < 2)
                {
                    if (_local_7 < _local_2.length)
                    {
                        this._MainPropertyTxt[_local_7].htmlText = _local_2[_local_7];
                        this._MainPropertyTxt[_local_7].y = (((this._NeedLevel.y + this._NeedLevel.textHeight) + 10) + (24 * _local_7));
                        this._MainPropertyTxt[_local_7].visible = true;
                        if (this._EquipInfo.TemplateType == 5)
                        {
                            this._AngleTxt.text = ((((((LanguageMgr.GetTranslation("ddt.angle") + ":") + this._info.Property5) + "°") + "~") + this._info.Property6) + "°");
                            this._AngleTxt.visible = true;
                            this._AngleTxt.x = this._MainPropertyTxt[_local_7].x;
                            this._AngleTxt.y = ((this._MainPropertyTxt[_local_7].y + this._MainPropertyTxt[_local_7].textHeight) + 6);
                            this._thisHeight = (this._AngleTxt.y + this._AngleTxt.textHeight);
                            this._rule3.y = ((this._AngleTxt.y + this._AngleTxt.textHeight) + 12);
                        }
                        else
                        {
                            this._AngleTxt.visible = false;
                            this._rule3.y = ((this._MainPropertyTxt[_local_7].y + this._MainPropertyTxt[_local_7].textHeight) + 12);
                        };
                    }
                    else
                    {
                        this._MainPropertyTxt[_local_7].visible = false;
                    };
                    _local_7++;
                };
                this._thisHeight = (this._rule3.y + this._rule3.height);
            };
        }

        private function showMiddleTwoPart():void
        {
            var _local_4:EquipmentTemplateInfo;
            var _local_1:Array = new Array();
            var _local_2:int = 1;
            while (_local_2 < 7)
            {
                _local_4 = ItemManager.Instance.getEquipPropertyListById(this._EquipInfo[(("MinorProperty" + _local_2) + "ID")]);
                if (this._EquipInfo[(("MinorProperty" + _local_2) + "ID")] != 0)
                {
                    _local_1.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr1", _local_4.PropertyName, this._EquipInfo[(("MinorProperty" + _local_2) + "Value")]));
                };
                _local_2++;
            };
            if (_local_1.length == 0)
            {
                this._rule4.visible = false;
                this._Property = false;
            }
            else
            {
                this._rule4.visible = true;
                this._Property = true;
            };
            var _local_3:int;
            while (_local_3 < 6)
            {
                if (_local_3 < _local_1.length)
                {
                    this._propVec[_local_3].text = _local_1[_local_3];
                    this._propVec[_local_3].textColor = 6277377;
                    this._propVec[_local_3].y = (((this._rule3.y + this._rule3.height) + 8) + (24 * _local_3));
                    this._propVec[_local_3].visible = true;
                    this._rule4.y = ((this._propVec[_local_3].y + this._propVec[_local_3].textHeight) + 12);
                    this._thisHeight = (this._rule4.y + this._rule4.height);
                }
                else
                {
                    this._propVec[_local_3].visible = false;
                };
                _local_3++;
            };
        }

        private function showRefiningPart():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:RefiningConfigInfo;
            var _local_4:RefiningConfigInfo;
            var _local_5:int;
            var _local_6:int;
            this._rule6.visible = false;
            this._refiningTitleTxt.visible = false;
            this._refiningTitleDec.visible = false;
            var _local_1:int;
            while (_local_1 < this._refiningTxtVec.length)
            {
                this._refiningTxtVec[_local_1].visible = false;
                _local_1++;
            };
            if (ItemManager.Instance.judgeJewelry(this._info))
            {
                if ((this._info is InventoryItemInfo))
                {
                    this._rule6.visible = true;
                    this._refiningTitleTxt.visible = true;
                    _local_2 = (this._info as InventoryItemInfo);
                    this._thisHeight = (this._thisHeight + 6);
                    _local_3 = StoreController.instance.Model.getRefiningConfigByLevel(_local_2.StrengthenLevel);
                    _local_4 = StoreController.instance.Model.getRefiningConfigByLevel(this._EquipInfo.StrengthLimit);
                    if (((!(_local_3)) || (_local_2.StrengthenLevel == 0)))
                    {
                        this._refiningTitleTxt.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitle2");
                        this._refiningTitleTxt.y = this._thisHeight;
                        this._thisHeight = (this._thisHeight + this._refiningTitleTxt.height);
                        this._refiningTitleDec.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitleDic", _local_4.Desc);
                        this._refiningTitleDec.y = this._thisHeight;
                        this._thisHeight = (this._thisHeight + this._refiningTitleDec.height);
                    }
                    else
                    {
                        this._refiningTitleDec.visible = true;
                        _local_5 = 0;
                        while (_local_5 < this._refiningTxtVec.length)
                        {
                            this._refiningTxtVec[_local_5].visible = true;
                            _local_5++;
                        };
                        this._refiningTitleTxt.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitle1");
                        this._refiningTitleTxt.y = this._thisHeight;
                        this._thisHeight = (this._thisHeight + this._refiningTitleTxt.height);
                        this._refiningTitleDec.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitleDic", _local_4.Desc);
                        this._refiningTitleDec.y = this._thisHeight;
                        this._thisHeight = (this._thisHeight + this._refiningTitleDec.height);
                        this._refiningTxtVec[0].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt0", _local_3.Blood);
                        this._refiningTxtVec[1].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt1", _local_3.Attack);
                        this._refiningTxtVec[2].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt2", _local_3.Defence);
                        this._refiningTxtVec[3].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt3", _local_3.Agility);
                        this._refiningTxtVec[4].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt4", _local_3.Lucky);
                        _local_6 = 0;
                        while (_local_6 < this._refiningTxtVec.length)
                        {
                            this._refiningTxtVec[_local_6].y = this._thisHeight;
                            this._thisHeight = (this._thisHeight + this._refiningTxtVec[_local_6].height);
                            _local_6++;
                        };
                    };
                    this._rule6.y = (this._thisHeight + 6);
                    this._thisHeight = (this._rule6.y + this._rule6.height);
                };
            };
        }

        private function showEmbedInfo():void
        {
            var _local_1:int;
            var _local_3:Array;
            this._rule5.visible = false;
            var _local_2:Boolean;
            if ((this._info is InventoryItemInfo))
            {
                _local_1 = 0;
                while (_local_1 < MAX_HOLE)
                {
                    if (this._info[("Hole" + (_local_1 + 1))])
                    {
                        if ((!(_local_2)))
                        {
                            this._thisHeight = (this._thisHeight + 6);
                            this._rule5.visible = true;
                            _local_2 = true;
                        };
                        this._embedVec[_local_1].holeID = this._info[("Hole" + (_local_1 + 1))];
                        this._embedVec[_local_1].y = this._thisHeight;
                        this._thisHeight = (this._thisHeight + this._embedVec[_local_1].height);
                        this._embedVec[_local_1].visible = true;
                    }
                    else
                    {
                        this._embedVec[_local_1].visible = false;
                    };
                    _local_1++;
                };
            }
            else
            {
                if ((this._info is ItemTemplateInfo))
                {
                    _local_1 = 0;
                    while (_local_1 < 4)
                    {
                        _local_3 = EquipType.getEmbedHoleInfo(this._info, _local_1);
                        if (_local_3[0] != 0)
                        {
                            if ((!(_local_2)))
                            {
                                this._thisHeight = (this._thisHeight + 6);
                                this._rule5.visible = true;
                                _local_2 = true;
                            };
                            if (((_local_3[0] == "-1") && (_local_3[1] == "0")))
                            {
                                this._embedVec[_local_1].holeID = 1;
                            }
                            else
                            {
                                this._embedVec[_local_1].holeID = _local_3[0];
                            };
                            this._embedVec[_local_1].y = this._thisHeight;
                            this._thisHeight = (this._thisHeight + this._embedVec[_local_1].height);
                            this._embedVec[_local_1].visible = true;
                        }
                        else
                        {
                            this._embedVec[_local_1].visible = false;
                        };
                        _local_1++;
                    };
                };
            };
            if (_local_2)
            {
                this._rule5.y = (this._thisHeight + 6);
                this._thisHeight = (this._rule5.y + this._rule5.height);
            };
        }

        private function showButtomPart():void
        {
            var _local_4:RefiningConfigInfo;
            this._DescriptionTxt.text = ((LanguageMgr.GetTranslation("ddt.EquipTipPanel.Description") + "\n") + this._info.Description);
            this._DescriptionTxt.x = this._equipPosition.x;
            this._DescriptionTxt.y = (this._thisHeight + 12);
            var _local_1:int;
            if (((((this._EquipInfo.TemplateType == 7) || (this._EquipInfo.TemplateType == 8)) || (this._EquipInfo.TemplateType == 9)) || (this._EquipInfo.TemplateType == 10)))
            {
                _local_1 = (_local_1 + (4 * Math.pow(2, (EquipmentTemplateInfo.MAX_SMELT_LEVEL + 1))));
            }
            else
            {
                _local_1 = (_local_1 + Math.pow(this._EquipInfo.StrengthLimit, 2));
            };
            _local_1 = (_local_1 + this.getPropertyPoint(this._EquipInfo.MainProperty1ID, this._EquipInfo.MainProperty1Value));
            _local_1 = (_local_1 + this.getPropertyPoint(this._EquipInfo.MainProperty2ID, this._EquipInfo.MainProperty2Value));
            var _local_2:int = 1;
            while (_local_2 < 7)
            {
                _local_1 = (_local_1 + this.getPropertyPoint(this._EquipInfo[(("MinorProperty" + _local_2) + "ID")], this._EquipInfo[(("MinorProperty" + _local_2) + "Value")]));
                _local_2++;
            };
            var _local_3:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (_local_3)
            {
                _local_4 = StoreController.instance.Model.getRefiningConfigByLevel(_local_3.StrengthenLevel);
                _local_1 = (_local_1 + this.getPropertyPoint(7, _local_4.Blood));
                _local_1 = (_local_1 + this.getPropertyPoint(1, _local_4.Attack));
                _local_1 = (_local_1 + this.getPropertyPoint(2, _local_4.Defence));
                _local_1 = (_local_1 + this.getPropertyPoint(3, _local_4.Agility));
                _local_1 = (_local_1 + this.getPropertyPoint(4, _local_4.Lucky));
            };
            this._equipScore.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.equipScore", _local_1);
            this._equipScore.y = ((this._DescriptionTxt.y + this._DescriptionTxt.textHeight) + 12);
            this._thisHeight = (this._equipScore.y + this._equipScore.textHeight);
        }

        private function getPropertyPoint(_arg_1:int, _arg_2:int):int
        {
            switch (_arg_1)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                    return (_arg_2 * 2);
                case 5:
                case 6:
                    return (_arg_2 * 5);
                case 7:
                    return (_arg_2);
                case 8:
                    return (_arg_2 * 10);
                default:
                    return (0);
            };
        }

        private function showRemainTime():void
        {
            var _local_1:InventoryItemInfo;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            var _local_7:ShopItemInfo;
            this._timeRule.visible = (this._restTimeTxt.visible = false);
            if ((this._info is InventoryItemInfo))
            {
                _local_1 = InventoryItemInfo(this._info);
                if (_local_1.ValidDate > 0)
                {
                    _local_2 = _local_1.getRemainSecond();
                    _local_3 = int((_local_2 / DateUtils.DAY_SECONDS));
                    _local_4 = int(((_local_2 % DateUtils.DAY_SECONDS) / DateUtils.HOUR_SECONDS));
                    _local_5 = int(((_local_2 % DateUtils.HOUR_SECONDS) / DateUtils.MINITE_SECONDS));
                    if ((!(_local_1.IsUsed)))
                    {
                        this._restTimeTxt.text = ((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time") + _local_1.ValidDate) + LanguageMgr.GetTranslation("day"));
                        this._restTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                    }
                    else
                    {
                        if (_local_2 > 0)
                        {
                            _local_6 = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less");
                            if (_local_3 > 1)
                            {
                                _local_6 = (_local_6 + (_local_3 + LanguageMgr.GetTranslation("day")));
                            }
                            else
                            {
                                if (_local_3 > 0)
                                {
                                    _local_6 = (_local_6 + (_local_3 + LanguageMgr.GetTranslation("day")));
                                    if (_local_4 > 0)
                                    {
                                        _local_6 = (_local_6 + (_local_4 + LanguageMgr.GetTranslation("hours")));
                                    };
                                }
                                else
                                {
                                    if (_local_4 > 0)
                                    {
                                        _local_6 = (_local_6 + (_local_4 + LanguageMgr.GetTranslation("hours")));
                                    };
                                    _local_6 = (_local_6 + ((_local_5 + 1) + LanguageMgr.GetTranslation("minute")));
                                };
                            };
                            this._restTimeTxt.text = _local_6;
                            this._restTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                        }
                        else
                        {
                            this._restTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
                            this._restTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
                        };
                    };
                    this._timeRule.visible = (this._restTimeTxt.visible = true);
                    this._timeRule.y = (this._thisHeight + 12);
                    this._restTimeTxt.y = ((this._timeRule.y + this._timeRule.height) + 2);
                    this._thisHeight = (this._restTimeTxt.y + this._restTimeTxt.textHeight);
                };
            }
            else
            {
                _local_7 = ShopManager.Instance.getGoodsByTemplateID(this._info.TemplateID);
                if ((((_local_7) && (_local_7.BuyType == 0)) && (_local_7.AUnit > 0)))
                {
                    this._timeRule.visible = (this._restTimeTxt.visible = true);
                    this._restTimeTxt.text = ((LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time") + _local_7.AUnit) + LanguageMgr.GetTranslation("day"));
                    this._restTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                    this._timeRule.y = (this._thisHeight + 12);
                    this._restTimeTxt.y = ((this._timeRule.y + this._timeRule.height) + 2);
                    this._thisHeight = (this._restTimeTxt.y + this._restTimeTxt.textHeight);
                };
            };
        }

        private function upBackground():void
        {
            this._bg.height = (this._thisHeight + 14);
            this._bg.width = (THISWIDTH + (this._type * 10));
            this.updateWH();
        }

        private function updateWH():void
        {
            _width = (this._bg.width + 17);
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            this._equipName = null;
            this._StrengthLimit = null;
            this._equipPosition = null;
            this._NeedLevel = null;
            var _local_1:int;
            while (_local_1 < this._MainPropertyTxt.length)
            {
                ObjectUtils.disposeObject(this._MainPropertyTxt[_local_1]);
                this._MainPropertyTxt[_local_1] = null;
                _local_1++;
            };
            this._MainPropertyTxt = null;
            var _local_2:int;
            while (_local_2 < this._propVec.length)
            {
                ObjectUtils.disposeObject(this._propVec[_local_2]);
                this._propVec[_local_2] = null;
                _local_2++;
            };
            this._propVec = null;
            var _local_3:int;
            while (_local_3 < this._refiningTxtVec.length)
            {
                ObjectUtils.disposeObject(this._refiningTxtVec[_local_3]);
                this._refiningTxtVec[_local_3] = null;
                _local_3++;
            };
            this._refiningTxtVec = null;
            ObjectUtils.disposeObject(this._refiningTitleTxt);
            this._refiningTitleTxt = null;
            ObjectUtils.disposeObject(this._refiningTitleDec);
            this._refiningTitleDec = null;
            ObjectUtils.disposeObject(this._rule3);
            this._rule3 = null;
            ObjectUtils.disposeObject(this._rule4);
            this._rule4 = null;
            ObjectUtils.disposeObject(this._rule5);
            this._rule5 = null;
            ObjectUtils.disposeObject(this._rule6);
            this._rule6 = null;
            this._info = null;
            this._EquipInfo = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

