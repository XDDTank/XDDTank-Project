// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StrengthTips

package store.view.strength
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import ddt.view.tips.EquipTipEmbedItem;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipStrengthInfo;
    import com.pickgliss.utils.ObjectUtils;
    import store.data.RefiningConfigInfo;
    import store.StoreController;
    import ddt.manager.LanguageMgr;
    import ddt.data.EquipType;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import __AS3__.vec.*;

    public class StrengthTips extends BaseTip implements ITip, Disposeable 
    {

        public static const THISWIDTH:int = 200;
        public static const MAX_HOLE:int = 4;

        private var _bg:ScaleBitmapImage;
        private var _equipName:FilterFrameText;
        private var _StrengthLimit:FilterFrameText;
        private var _equipPosition:FilterFrameText;
        private var _NeedLevel:FilterFrameText;
        private var _MainPropertyTxt:Vector.<FilterFrameText>;
        private var _refiningTitleTxt:FilterFrameText;
        private var _refiningTitleDec:FilterFrameText;
        private var _refiningTxtVec:Vector.<FilterFrameText>;
        private var _embedVec:Vector.<EquipTipEmbedItem>;
        private var _propVec:Vector.<FilterFrameText>;
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
        private var _laterEquipmentView:NewLaterEquipmentView;
        private var _Property:Boolean;
        private var _AngleTxt:FilterFrameText;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._rule3 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule4 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule5 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._rule6 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            this._equipName = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.name");
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
            super.init();
            super.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._equipName);
            addChild(this._StrengthLimit);
            addChild(this._equipPosition);
            addChild(this._AngleTxt);
            addChild(this._NeedLevel);
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
                this.laterEquipment(this._info);
            }
            else
            {
                this.visible = false;
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
            this.upBackground();
        }

        private function laterEquipment(_arg_1:ItemTemplateInfo):void
        {
            var _local_4:InventoryItemInfo;
            var _local_5:EquipmentTemplateInfo;
            var _local_6:EquipStrengthInfo;
            var _local_2:InventoryItemInfo;
            var _local_3:ItemTemplateInfo;
            if (_arg_1)
            {
                _local_4 = (_arg_1 as InventoryItemInfo);
                _local_5 = ItemManager.Instance.getEquipTemplateById(_local_4.TemplateID);
            };
            if (((_local_5) && (_local_4.StrengthenLevel < _local_5.StrengthLimit)))
            {
                _local_2 = new InventoryItemInfo();
                _local_3 = new ItemTemplateInfo();
                ObjectUtils.copyProperties(_local_2, _local_4);
                _local_2.StrengthenLevel = (_local_2.StrengthenLevel + 1);
                _local_6 = ItemManager.Instance.getEquipStrengthInfoByLevel(_local_2.StrengthenLevel, _local_5.QualityID);
                if (_local_6)
                {
                };
                if ((!(this._laterEquipmentView)))
                {
                    this._laterEquipmentView = new NewLaterEquipmentView();
                };
                this._laterEquipmentView.x = ((this._bg.x + this._bg.width) + 48);
                if ((!(this.contains(this._laterEquipmentView))))
                {
                    addChild(this._laterEquipmentView);
                };
                this._laterEquipmentView.tipData = _arg_1;
            }
            else
            {
                if (this._laterEquipmentView)
                {
                    ObjectUtils.disposeObject(this._laterEquipmentView);
                };
                this._laterEquipmentView = null;
            };
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
            this._StrengthLimit.x = this._equipName.x;
            this._StrengthLimit.y = ((this._equipName.y + this._equipName.textHeight) + 10);
        }

        private function showHeadTwoPart():void
        {
            var _local_1:InventoryItemInfo = (this._info as InventoryItemInfo);
            if (_local_1)
            {
                this._bindImage.setFrame(((_local_1.IsBinds) ? 1 : 2));
                PositionUtils.setPos(this._bindImage, "ddtcore.equipTip.BindPos");
                addChild(this._bindImage);
            };
            this._equipPosition.text = LanguageMgr.GetTranslation(("ddt.EquipTipPanel.PositionTxt" + this._EquipInfo.TemplateType));
            this._equipPosition.y = ((this._StrengthLimit.y + this._StrengthLimit.textHeight) + 18);
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
            this._NeedLevel.y = ((this._equipPosition.y + this._equipPosition.textHeight) + 8);
            this._thisHeight = (this._NeedLevel.y + this._NeedLevel.textHeight);
        }

        private function showMiddlePart():void
        {
            var _local_5:int;
            var _local_6:int;
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
                _local_2.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr", _local_3.PropertyName, this._EquipInfo.MainProperty1Value, ((_local_1.StrengthenLevel > 0) ? ((!(_local_5 == 0)) ? (("(+" + _local_5) + ")") : "") : "")));
            };
            if (this._EquipInfo.MainProperty2ID != 0)
            {
                _local_2.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr", _local_4.PropertyName, this._EquipInfo.MainProperty2Value, ((_local_1.StrengthenLevel > 0) ? ((!(_local_6 == 0)) ? (("(+" + _local_6) + ")") : "") : "")));
            };
            var _local_7:int;
            while (_local_7 < 2)
            {
                if (_local_7 < _local_2.length)
                {
                    this._MainPropertyTxt[_local_7].htmlText = _local_2[_local_7];
                    this._MainPropertyTxt[_local_7].y = (((this._NeedLevel.y + this._NeedLevel.textHeight) + 10) + (24 * _local_7));
                    this._MainPropertyTxt[_local_7].visible = true;
                    if (this._EquipInfo.TemplateType == 5)
                    {
                        this._AngleTxt.text = ((((("角度:" + this._info.Property5) + "°") + "~") + this._info.Property6) + "°");
                        this._AngleTxt.visible = true;
                        this._AngleTxt.x = this._MainPropertyTxt[_local_7].x;
                        this._AngleTxt.y = ((this._MainPropertyTxt[_local_7].y + this._MainPropertyTxt[_local_7].textHeight) + 8);
                        this._thisHeight = (this._AngleTxt.y + this._AngleTxt.textHeight);
                        this._rule3.x = this._AngleTxt.x;
                        this._rule3.y = ((this._AngleTxt.y + this._AngleTxt.textHeight) + 12);
                    }
                    else
                    {
                        this._AngleTxt.visible = false;
                        this._rule3.x = this._MainPropertyTxt[_local_7].x;
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
                    this._propVec[_local_3].visible = true;
                    this._propVec[_local_3].y = (((this._rule3.y + this._rule3.height) + 8) + (24 * _local_3));
                    this._rule4.x = this._propVec[_local_3].x;
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
                    this._refiningTitleDec.visible = true;
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
                    _local_3 = EquipType.getEmbedHoleInfo(this._info, _local_1);
                    if (_local_3[0] != 0)
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
                            this._embedVec[_local_1].holeID = _local_3[0];
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
            var _local_4:RefiningConfigInfo = StoreController.instance.Model.getRefiningConfigByLevel(_local_3.StrengthenLevel);
            _local_1 = (_local_1 + this.getPropertyPoint(7, _local_4.Blood));
            _local_1 = (_local_1 + this.getPropertyPoint(1, _local_4.Attack));
            _local_1 = (_local_1 + this.getPropertyPoint(2, _local_4.Defence));
            _local_1 = (_local_1 + this.getPropertyPoint(3, _local_4.Agility));
            _local_1 = (_local_1 + this.getPropertyPoint(4, _local_4.Lucky));
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

        private function upBackground():void
        {
            this._bg.height = (this._thisHeight + 13);
            this._bg.width = THISWIDTH;
            this.updateWH();
        }

        private function updateWH():void
        {
            _width = this._bg.width;
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
                this._MainPropertyTxt[_local_1] = null;
                _local_1++;
            };
            this._MainPropertyTxt = null;
            var _local_2:int;
            while (_local_2 < this._refiningTxtVec.length)
            {
                ObjectUtils.disposeObject(this._refiningTxtVec[_local_2]);
                this._refiningTxtVec[_local_2] = null;
                _local_2++;
            };
            this._refiningTxtVec = null;
            ObjectUtils.disposeObject(this._refiningTitleTxt);
            this._refiningTitleTxt = null;
            ObjectUtils.disposeObject(this._refiningTitleDec);
            this._refiningTitleDec = null;
            var _local_3:int;
            while (_local_3 < this._propVec.length)
            {
                this._propVec[_local_3] = null;
                _local_3++;
            };
            this._propVec = null;
            ObjectUtils.disposeObject(this._rule3);
            this._rule3 = null;
            ObjectUtils.disposeObject(this._rule4);
            this._rule4 = null;
            ObjectUtils.disposeObject(this._rule5);
            this._rule5 = null;
            ObjectUtils.disposeObject(this._rule6);
            this._rule6 = null;
            this._info = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

