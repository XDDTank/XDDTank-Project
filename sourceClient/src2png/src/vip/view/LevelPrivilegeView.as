// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.LevelPrivilegeView

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import flash.utils.Dictionary;
    import ddt.manager.LanguageMgr;
    import ddt.data.VipConfigInfo;
    import ddt.manager.VipPrivilegeConfigManager;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class LevelPrivilegeView extends Sprite implements Disposeable 
    {

        private static const MAX_LEVEL:int = 10;
        private static const VIP_SETTINGS_FIELD:Array = ["VIPRateForGP", "VIPStrengthenEx", "VIPQuestStar", "VIPLotteryCountMaxPerDay", "VIPExtraBindMoneyUpper", "VIPTakeCardDisCount", "VIPQuestFinishDirect", "VIPLotteryNoTime", "VIPBossBattle", "CanBuyFert", "FarmAssistant", "PetFifthSkill", "LoginSysNotice", "VIPMetalRelieve", "VIPWeekly", "VIPBenediction"];

        private var _bg:Image;
        private var _titleBg:Bitmap;
        private var _titleSeperators:Image;
        private var _titleTxt:FilterFrameText;
        private var _titleIcons:Vector.<Image>;
        private var _itemScrollPanel:ScrollPanel;
        private var _itemContainer:VBox;
        private var _currentVip:Image;
        private var _units:Dictionary;
        private var _minPrivilegeLevel:Dictionary = new Dictionary();

        public function LevelPrivilegeView()
        {
            this._units = new Dictionary();
            this._units[0] = (this._units[1] = (this._units[9] = (this._units[10] = "%")));
            this._units[2] = (this._units[3] = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.TimesUnit"));
            this.initView();
            this.initItem();
        }

        private function initItem():void
        {
            var _local_2:PrivilegeViewItem;
            var _local_3:VipConfigInfo;
            var _local_4:Vector.<String>;
            var _local_5:int;
            var _local_1:int;
            while (_local_1 < 11)
            {
                _local_2 = null;
                _local_3 = VipPrivilegeConfigManager.Instance.getById((_local_1 + 1));
                if (!(((((_local_1 == 4) || (_local_1 == 5)) || (_local_1 == 6)) || (_local_1 == 7)) || (_local_1 == 8)))
                {
                    if (this._units[_local_1] != null)
                    {
                        if (((_local_1 == 9) || (_local_1 == 10)))
                        {
                            _local_2 = new PrivilegeViewItem(_local_1, PrivilegeViewItem.UNIT_TYPE, this._units[_local_1]);
                        }
                        else
                        {
                            _local_2 = new PrivilegeViewItem((_local_1 + 1), PrivilegeViewItem.UNIT_TYPE, this._units[_local_1]);
                        };
                    }
                    else
                    {
                        _local_2 = new PrivilegeViewItem((_local_1 + 1));
                    };
                    _local_2.itemTitleText = LanguageMgr.GetTranslation(("ddt.vip.PrivilegeViewItem" + (_local_1 + 1)));
                    _local_4 = new Vector.<String>();
                    _local_5 = 1;
                    while (_local_5 <= 10)
                    {
                        _local_4.push(int(_local_3[("Level" + _local_5)]));
                        _local_5++;
                    };
                    _local_2.itemContent = _local_4;
                    this._itemContainer.addChild(_local_2);
                };
                _local_1++;
            };
            this.parsePrivilegeItem(5);
            this.parsePrivilegeItem(8);
            this.parsePrivilegeItem(9);
            this.parsePrivilegeItem(6);
            this.parsePrivilegeItem(7);
            this._itemScrollPanel.invalidateViewport();
        }

        private function parsePrivilegeItem(_arg_1:int):void
        {
            var _local_6:int;
            var _local_2:Array = new Array();
            var _local_3:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_arg_1);
            if ((!(_local_3)))
            {
                return;
            };
            var _local_4:int = 1;
            while (_local_4 <= MAX_LEVEL)
            {
                _local_6 = int(_local_3[("Level" + _local_4)]);
                _local_2.push(((_local_6 == 1) ? "1" : "0"));
                _local_4++;
            };
            var _local_5:PrivilegeViewItem = new PrivilegeViewItem(_arg_1, PrivilegeViewItem.TRUE_FLASE_TYPE);
            _local_5.itemTitleText = LanguageMgr.GetTranslation(("ddt.vip.PrivilegeViewItem" + _arg_1));
            _local_5.itemContent = Vector.<String>(_local_2);
            this._itemContainer.addChild(_local_5);
        }

        private function parseBenediction():void
        {
            var _local_1:int;
            var _local_2:int = 2;
            var _local_3:Vector.<String> = Vector.<String>(["0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]);
            var _local_4:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_local_2);
            if ((!(_local_4)))
            {
                return;
            };
            var _local_5:PrivilegeViewItem;
            var _local_6:int;
            while (_local_6 < 10)
            {
                if (_local_6 < 4)
                {
                    _local_3[_local_6] = "0";
                    _local_5 = new PrivilegeViewItem(_local_2);
                }
                else
                {
                    _local_3[_local_6] = _local_4[("Level" + (_local_6 + 1))];
                    _local_5 = new PrivilegeViewItem(_local_2, PrivilegeViewItem.UNIT_TYPE, "%");
                };
                _local_5.itemTitleText = LanguageMgr.GetTranslation(("ddt.vip.PrivilegeViewItem" + _local_2));
                _local_5.itemContent = _local_3;
                _local_6++;
            };
            this._itemContainer.addChild(_local_5);
        }

        private function benedictionAnalyzer(_arg_1:Vector.<String>):Vector.<DisplayObject>
        {
            var _local_2:Vector.<DisplayObject>;
            var _local_4:String;
            var _local_5:DisplayObject;
            _local_2 = new Vector.<DisplayObject>();
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeBenedctionItemTxtStartPos");
            for each (_local_4 in _arg_1)
            {
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
                PositionUtils.setPos(_local_5, _local_3);
                _local_5.x = (_local_3.x + (40 - _local_5.width));
                _local_3.x = (_local_3.x + (40 + 15));
                _local_2.push(_local_5);
            };
            return (_local_2);
        }

        private function initView():void
        {
            var _local_4:Image;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeViewBg");
            this._titleBg = ComponentFactory.Instance.creatBitmap("vip.LevelPrivilegeTitleBg");
            this._titleSeperators = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewTitleItemSeperators");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.TitleTxt");
            this._titleTxt.text = LanguageMgr.GetTranslation("ddt.vip.LevelPrivilegeView.TitleTxt");
            this._currentVip = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.currentVip");
            this._currentVip.x = (this._currentVip.x + ((PlayerManager.Instance.Self.VIPLevel - 1) * 57));
            this._currentVip.visible = PlayerManager.Instance.Self.IsVIP;
            addChild(this._bg);
            addChild(this._titleBg);
            addChild(this._titleSeperators);
            addChild(this._titleTxt);
            this._titleIcons = new Vector.<Image>();
            var _local_1:int;
            var _local_2:int;
            var _local_3:int = 1;
            while (_local_3 <= MAX_LEVEL)
            {
                _local_4 = ComponentFactory.Instance.creatComponentByStylename(("vip.LevelPrivilegeView.VipIcon" + _local_3));
                this._titleIcons.push(_local_4);
                addChild(_local_4);
                if (_local_3 == 1)
                {
                    _local_1 = _local_4.x;
                    _local_2 = _local_4.y;
                }
                else
                {
                    if (_local_3 == 10)
                    {
                        _local_4.x = 642;
                        _local_4.y = 57;
                    }
                    else
                    {
                        _local_1 = (_local_1 + 55);
                        _local_4.x = _local_1;
                        _local_4.y = _local_2;
                    };
                };
                _local_3++;
            };
            addChild(this._currentVip);
            this._itemScrollPanel = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.ItemScrollPanel");
            addChild(this._itemScrollPanel);
            this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemContainer");
            this._itemScrollPanel.setView(this._itemContainer);
        }

        public function dispose():void
        {
            var _local_1:Image;
            for each (_local_1 in this._titleIcons)
            {
                ObjectUtils.disposeObject(_local_1);
            };
            this._titleIcons = null;
            ObjectUtils.disposeObject(this._bg);
            ObjectUtils.disposeObject(this._titleBg);
            ObjectUtils.disposeObject(this._titleSeperators);
            ObjectUtils.disposeObject(this._titleTxt);
            ObjectUtils.disposeObject(this._itemContainer);
            ObjectUtils.disposeObject(this._itemScrollPanel);
            ObjectUtils.disposeObject(this._currentVip);
            this._bg = null;
            this._titleBg = null;
            this._titleSeperators = null;
            this._titleTxt = null;
            this._itemScrollPanel = null;
            this._itemContainer = null;
            this._currentVip = null;
        }


    }
}//package vip.view

