// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.SuidTips

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import ddt.data.player.PlayerInfo;
    import ddt.data.goods.SuidTipInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SuidTips extends BaseTip implements ITip, Disposeable 
    {

        public static const THISWIDTH:int = 220;

        private var _bg:ScaleBitmapImage;
        private var _tipTilte:FilterFrameText;
        private var _StrengthenLevelTxt:FilterFrameText;
        private var _propVec:Vector.<FilterFrameText>;
        private var _nextLevelTxt:FilterFrameText;
        private var _nextPropVec:Vector.<FilterFrameText>;
        private var _rule1:ScaleBitmapImage;
        private var _rule2:ScaleBitmapImage;
        private var _nextBitmap:Bitmap;
        private var _thisHeight:int;
        private var _playerInfo:PlayerInfo;
        private var _suidTipInfo:SuidTipInfo;


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
            this._nextBitmap = ComponentFactory.Instance.creatBitmap("asset.SuitIcon.NextBitmap");
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
            addChild(this._nextBitmap);
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
                this._suidTipInfo = ItemManager.Instance.getSuidListByLevle(this._playerInfo.SuidLevel);
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
            this._tipTilte.text = LanguageMgr.GetTranslation("ddt.SuidTipPanel.title");
            this._rule1.x = this._tipTilte.x;
            this._rule1.y = ((this._tipTilte.y + this._tipTilte.textHeight) + 12);
            this._thisHeight = (this._rule1.y + this._rule1.height);
        }

        private function showMiddlePart():void
        {
            var _local_3:int;
            if (this._playerInfo.EquipNum < 6)
            {
                this._StrengthenLevelTxt.visible = false;
                while (_local_3 < 8)
                {
                    this._propVec[_local_3].visible = false;
                    _local_3++;
                };
                this._nextBitmap.visible = false;
                this._rule1.visible = false;
                this._rule2.x = this._tipTilte.x;
                this._rule2.y = ((this._tipTilte.y + this._tipTilte.textHeight) + 12);
                this._nextBitmap.y = ((this._rule2.y + this._rule2.height) + 5);
                this._thisHeight = (this._rule2.y + this._rule2.height);
                return;
            };
            this._rule1.visible = true;
            var _local_1:Array = new Array();
            this._StrengthenLevelTxt.text = LanguageMgr.GetTranslation("ddt.SuidTipPanel.StrengthenLevelTxt", this._playerInfo.SuidLevel);
            this._StrengthenLevelTxt.y = ((this._rule1.y + this._rule1.height) + 10);
            this._StrengthenLevelTxt.visible = true;
            if (this._suidTipInfo.Attack != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Attack", this._suidTipInfo.Attack));
            };
            if (this._suidTipInfo.Defence != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Defence", this._suidTipInfo.Defence));
            };
            if (this._suidTipInfo.Agility != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Agility", this._suidTipInfo.Agility));
            };
            if (this._suidTipInfo.Lucky != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Lucky", this._suidTipInfo.Lucky));
            };
            if (this._suidTipInfo.Guard != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Guard", this._suidTipInfo.Guard));
            };
            if (this._suidTipInfo.Damage != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Damage", this._suidTipInfo.Damage));
            };
            if (this._suidTipInfo.Blood != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Blood", this._suidTipInfo.Blood));
            };
            if (this._suidTipInfo.Energy != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Energy", this._suidTipInfo.Energy));
            };
            var _local_2:int;
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
            this._nextBitmap.visible = true;
            this._nextBitmap.y = ((this._rule2.y + this._rule2.height) + 5);
            this._thisHeight = (this._rule2.y + this._rule2.height);
        }

        private function showButtomPart():void
        {
            var _local_2:SuidTipInfo;
            var _local_3:int;
            var _local_4:int;
            if (this._playerInfo.SuidLevel == 55)
            {
                this._thisHeight = ((this._rule2.y + this._rule2.height) - 10);
                this._nextLevelTxt.visible = false;
                this._nextBitmap.visible = false;
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
            if (this._playerInfo.EquipNum < 6)
            {
                this._nextLevelTxt.text = LanguageMgr.GetTranslation("ddt.SuidTipPanel.nextLevelTxt", 10);
                _local_2 = ItemManager.Instance.getSuidListByLevle(10);
            }
            else
            {
                if (((this._playerInfo.SuidLevel <= 20) && (this._playerInfo.EquipNum == 6)))
                {
                    this._nextLevelTxt.text = LanguageMgr.GetTranslation("ddt.SuidTipPanel.nextLevelTxt", (this._playerInfo.SuidLevel + 10));
                    _local_2 = ItemManager.Instance.getSuidListByLevle((this._playerInfo.SuidLevel + 10));
                }
                else
                {
                    this._nextLevelTxt.text = LanguageMgr.GetTranslation("ddt.SuidTipPanel.nextLevelTxt", (this._playerInfo.SuidLevel + 5));
                    _local_2 = ItemManager.Instance.getSuidListByLevle((this._playerInfo.SuidLevel + 5));
                };
            };
            if (_local_2 == null)
            {
                return;
            };
            this._nextLevelTxt.visible = true;
            this._nextLevelTxt.y = ((this._rule2.y + this._rule2.height) + 10);
            if (_local_2.Attack != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Attack", _local_2.Attack));
            };
            if (_local_2.Defence != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Defence", _local_2.Defence));
            };
            if (_local_2.Agility != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Agility", _local_2.Agility));
            };
            if (_local_2.Lucky != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Lucky", _local_2.Lucky));
            };
            if (_local_2.Guard != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Guard", _local_2.Guard));
            };
            if (_local_2.Damage != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Damage", _local_2.Damage));
            };
            if (_local_2.Blood != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Blood", _local_2.Blood));
            };
            if (_local_2.Energy != 0)
            {
                _local_1.push(LanguageMgr.GetTranslation("ddt.SuidTipPanel.Energy", _local_2.Energy));
            };
            _local_3 = 0;
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
            this._nextBitmap = null;
            this._playerInfo = null;
            this._suidTipInfo = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

