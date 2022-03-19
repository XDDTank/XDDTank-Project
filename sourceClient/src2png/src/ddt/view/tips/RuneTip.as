// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.RuneTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import ddt.data.player.PlayerInfo;
    import ddt.data.goods.RuneSuitInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class RuneTip extends BaseTip 
    {

        public static const THISWIDTH:int = 236;

        private var _bg:ScaleBitmapImage;
        private var _tipTilte:FilterFrameText;
        private var _StrengthenLevelTxt:FilterFrameText;
        private var _propVec:Vector.<FilterFrameText>;
        private var _nextLevelTxt:FilterFrameText;
        private var _nextPropVec:Vector.<FilterFrameText>;
        private var _rule1:ScaleBitmapImage;
        private var _rule2:ScaleBitmapImage;
        private var _thisHeight:int;
        private var _playerInfo:PlayerInfo;
        private var _runeTipInfo:RuneSuitInfo;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._tipTilte = ComponentFactory.Instance.creatComponentByStylename("SuidTips.title");
            this._StrengthenLevelTxt = ComponentFactory.Instance.creatComponentByStylename("SuidTips.StrengthenLevel");
            this._propVec = new Vector.<FilterFrameText>(8);
            var _local_1:int;
            while (_local_1 < 8)
            {
                this._propVec[_local_1] = ComponentFactory.Instance.creatComponentByStylename("SuidTips.propTxt");
                _local_1++;
            };
            this._nextLevelTxt = ComponentFactory.Instance.creatComponentByStylename("SuidTips.NextTxt");
            this._nextPropVec = new Vector.<FilterFrameText>(8);
            var _local_2:int;
            while (_local_2 < 8)
            {
                this._nextPropVec[_local_2] = ComponentFactory.Instance.creatComponentByStylename("SuidTips.NextTxt");
                _local_2++;
            };
            super.init();
            super.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._tipTilte);
            addChild(this._StrengthenLevelTxt);
            var _local_1:int;
            while (_local_1 < 8)
            {
                addChild(this._propVec[_local_1]);
                _local_1++;
            };
            addChild(this._nextLevelTxt);
            var _local_2:int;
            while (_local_2 < 8)
            {
                addChild(this._nextPropVec[_local_2]);
                _local_2++;
            };
            addChild(this._rule1);
            addChild(this._rule2);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if (_arg_1)
            {
                this._playerInfo = (_arg_1 as PlayerInfo);
                this.visible = true;
                this._runeTipInfo = ItemManager.Instance.getRuneListByLevel(this._playerInfo.runeLevel);
                this.upView();
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
            this.showMiddlePart();
            this.showButtomPart();
            this.upBackground();
        }

        private function showHeadPart():void
        {
            this._tipTilte.text = LanguageMgr.GetTranslation("ddt.RuneTipPanel.title");
            this._rule1.x = this._tipTilte.x;
            this._rule1.y = ((this._tipTilte.y + this._tipTilte.textHeight) + 12);
            this._thisHeight = (this._rule1.y + this._rule1.height);
        }

        private function showMiddlePart():void
        {
            var _local_2:int;
            var _local_3:int;
            if (this._playerInfo.runeLevel == 0)
            {
                this._StrengthenLevelTxt.visible = false;
                while (_local_3 < 8)
                {
                    this._propVec[_local_3].visible = false;
                    _local_3++;
                };
                this._rule1.visible = false;
                this._rule2.x = this._tipTilte.x;
                this._rule2.y = ((this._tipTilte.y + this._tipTilte.textHeight) + 12);
                this._thisHeight = (this._rule2.y + this._rule2.height);
                return;
            };
            this._rule1.visible = true;
            var _local_1:Array = new Array();
            this._StrengthenLevelTxt.text = LanguageMgr.GetTranslation("ddt.RuneTipPanel.EmbedLevelTxt", this._runeTipInfo.RuneCount, this._runeTipInfo.RuneLevel, this._runeTipInfo.RuneCount, this._runeTipInfo.RuneCount, this._runeTipInfo.RuneCount);
            this._StrengthenLevelTxt.y = ((this._rule1.y + this._rule1.height) + 10);
            this._StrengthenLevelTxt.visible = true;
            if (this._runeTipInfo.Attack != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Attack", this._runeTipInfo.Attack));
            };
            if (this._runeTipInfo.Defence != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Defence", this._runeTipInfo.Defence));
            };
            if (this._runeTipInfo.Agility != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Agility", this._runeTipInfo.Agility));
            };
            if (this._runeTipInfo.Lucky != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Lucky", this._runeTipInfo.Lucky));
            };
            if (this._runeTipInfo.Guard != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Guard", this._runeTipInfo.Guard));
            };
            if (this._runeTipInfo.Damage != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Damage", this._runeTipInfo.Damage));
            };
            if (this._runeTipInfo.Blood != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Blood", this._runeTipInfo.Blood));
            };
            _local_2 = 0;
            while (_local_2 < 8)
            {
                if (_local_2 < _local_1.length)
                {
                    this._propVec[_local_2].text = _local_1[_local_2];
                    this._propVec[_local_2].y = (((this._StrengthenLevelTxt.y + this._StrengthenLevelTxt.textHeight) + 8) + (20 * _local_2));
                    this._propVec[_local_2].visible = true;
                    this._rule2.x = this._propVec[_local_2].x;
                    this._rule2.y = ((this._propVec[_local_2].y + this._propVec[_local_2].textHeight) + 12);
                }
                else
                {
                    this._propVec[_local_2].visible = false;
                };
                _local_2++;
            };
            this._thisHeight = (this._rule2.y + this._rule2.height);
        }

        private function showButtomPart():void
        {
            var _local_2:RuneSuitInfo;
            var _local_4:int;
            if (this._playerInfo.runeLevel == ItemManager.Instance.getRuneMaxLevel())
            {
                this._thisHeight = ((this._rule2.y + this._rule2.height) - 10);
                this._nextLevelTxt.visible = false;
                this._rule2.visible = false;
                while (_local_4 < 8)
                {
                    this._nextPropVec[_local_4].visible = false;
                    _local_4++;
                };
                return;
            };
            this._rule2.visible = true;
            var _local_1:Array = new Array();
            _local_2 = ItemManager.Instance.getRuneListByLevel((this._playerInfo.runeLevel + 1));
            this._nextLevelTxt.text = LanguageMgr.GetTranslation("ddt.RuneTipPanel.EmbedLevelTxt", _local_2.RuneCount, _local_2.RuneLevel, _local_2.RuneCount, this.getNextRuneCount(_local_2), _local_2.RuneCount);
            if (_local_2 == null)
            {
                return;
            };
            this._nextLevelTxt.visible = true;
            this._nextLevelTxt.y = ((this._rule2.y + this._rule2.height) + 10);
            if (_local_2.Attack != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Attack", _local_2.Attack));
            };
            if (_local_2.Defence != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Defence", _local_2.Defence));
            };
            if (_local_2.Agility != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Agility", _local_2.Agility));
            };
            if (_local_2.Lucky != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Lucky", _local_2.Lucky));
            };
            if (_local_2.Guard != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Guard", _local_2.Guard));
            };
            if (_local_2.Damage != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Damage", _local_2.Damage));
            };
            if (_local_2.Blood != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Blood", _local_2.Blood));
            };
            var _local_3:int;
            while (_local_3 < 8)
            {
                if (_local_3 < _local_1.length)
                {
                    this._nextPropVec[_local_3].text = _local_1[_local_3];
                    this._nextPropVec[_local_3].visible = true;
                    this._nextPropVec[_local_3].y = (((this._nextLevelTxt.y + this._nextLevelTxt.textHeight) + 8) + (20 * _local_3));
                    this._thisHeight = (this._nextPropVec[_local_3].y + this._nextPropVec[_local_3].height);
                }
                else
                {
                    this._nextPropVec[_local_3].visible = false;
                };
                _local_3++;
            };
        }

        private function getNextRuneCount(_arg_1:RuneSuitInfo):int
        {
            var _local_4:ItemTemplateInfo;
            var _local_5:ItemTemplateInfo;
            var _local_7:int;
            var _local_2:int = _arg_1.RuneLevel;
            var _local_3:int;
            var _local_6:int;
            while (_local_6 <= 20)
            {
                _local_4 = this._playerInfo.Bag.getItemAt(_local_6);
                if (_local_4)
                {
                    _local_7 = 1;
                    while (_local_7 < 5)
                    {
                        if (_local_4[("Hole" + _local_7)] > 1)
                        {
                            _local_5 = ItemManager.Instance.getTemplateById(_local_4[("Hole" + _local_7)]);
                            if (((_local_5) && (int(_local_5.Property1) >= _local_2)))
                            {
                                _local_3++;
                            };
                        };
                        _local_7++;
                    };
                };
                _local_6++;
            };
            return (_local_3);
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
            this._tipTilte = null;
            this._StrengthenLevelTxt = null;
            this._nextLevelTxt = null;
            var _local_1:int;
            while (_local_1 < this._propVec.length)
            {
                this._propVec[_local_1] = null;
                _local_1++;
            };
            this._propVec = null;
            var _local_2:int;
            while (_local_1 < this._nextPropVec.length)
            {
                this._nextPropVec[_local_1] = null;
                _local_1++;
            };
            this._nextPropVec = null;
            this._rule1 = null;
            this._rule2 = null;
            this._playerInfo = null;
            this._runeTipInfo = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

