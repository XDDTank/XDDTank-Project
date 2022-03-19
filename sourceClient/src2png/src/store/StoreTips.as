// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StoreTips

package store
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Timer;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.TimerEvent;
    import ddt.manager.MessageTipManager;
    import com.greensock.TweenMax;
    import ddt.data.EquipType;
    import ddt.utils.StaticFormula;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.ChatManager;
    import com.pickgliss.utils.ObjectUtils;

    public class StoreTips extends Sprite implements Disposeable 
    {

        public static const TRANSFER:int = 0;
        public static const EMBED:int = 1;
        public static const COMPOSE:int = 2;
        public static const BEGIN_Y:int = 130;
        public static const SPACING:String = " ";
        public static const SPACINGII:String = " +";
        public static const SPACINGIII:String = " ";
        public static const Shield:int = 31;

        private var _timer:Timer;
        private var _successBit:Bitmap;
        private var _failBit:Bitmap;
        private var _fiveFailBit:Bitmap;
        private var _changeTxtI:FilterFrameText;
        private var _changeTxtII:FilterFrameText;
        private var _moveSprite:Sprite;
        public var isDisplayerTip:Boolean = true;
        private var _lastTipString:String = "";

        public function StoreTips()
        {
            this.init();
        }

        private function init():void
        {
            this._successBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIISuccessBitAsset");
            this._failBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIIFailBitAsset");
            this._fiveFailBit = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIIFiveFailBitAsset");
            this._changeTxtI = ComponentFactory.Instance.creatComponentByStylename("ddtstore.storeTipTxt");
            this._changeTxtII = ComponentFactory.Instance.creatComponentByStylename("ddtstore.storeTipTxt");
            this._moveSprite = new Sprite();
            addChild(this._moveSprite);
            this._timer = new Timer(7500, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
        }

        private function createTween(_arg_1:Function=null, _arg_2:Array=null):void
        {
            MessageTipManager.getInstance().kill();
            TweenMax.killTweensOf(this._moveSprite);
            TweenMax.from(this._moveSprite, 0.4, {
                "y":BEGIN_Y,
                "alpha":0
            });
            TweenMax.to(this._moveSprite, 0.4, {
                "delay":1.4,
                "y":(BEGIN_Y * -1),
                "alpha":0,
                "onComplete":((_arg_1 == null) ? this.removeTips : _arg_1),
                "onCompleteParams":_arg_2
            });
        }

        private function showPropertyChange(_arg_1:InventoryItemInfo):String
        {
            var _local_2:Number;
            var _local_3:String = "";
            var _local_4:String = "";
            if (EquipType.isArm(_arg_1))
            {
                _local_2 = (StaticFormula.getHertAddition(int(_arg_1.Property7), _arg_1.StrengthenLevel) - StaticFormula.getHertAddition(int(_arg_1.Property7), (_arg_1.StrengthenLevel - 1)));
                _local_3 = LanguageMgr.GetTranslation("store.storeTip.hurt", SPACING, SPACINGII, _local_2);
                _local_4 = LanguageMgr.GetTranslation("store.storeTip.chatHurt", _local_2);
            }
            else
            {
                if (int(_arg_1.Property3) == 32)
                {
                    _local_2 = (StaticFormula.getRecoverHPAddition(int(_arg_1.Property7), _arg_1.StrengthenLevel) - StaticFormula.getRecoverHPAddition(int(_arg_1.Property7), (_arg_1.StrengthenLevel - 1)));
                    _local_3 = LanguageMgr.GetTranslation("store.storeTip.AddHP", SPACING, SPACINGII, _local_2);
                    _local_4 = LanguageMgr.GetTranslation("store.storeTip.chatAddHP", _local_2);
                }
                else
                {
                    if (int(_arg_1.Property3) == Shield)
                    {
                        _local_2 = (StaticFormula.getDefenseAddition(int(_arg_1.Property7), _arg_1.StrengthenLevel) - StaticFormula.getDefenseAddition(int(_arg_1.Property7), (_arg_1.StrengthenLevel - 1)));
                        _local_3 = LanguageMgr.GetTranslation("store.storeTip.subHurt", SPACING, SPACINGII, _local_2);
                        _local_4 = LanguageMgr.GetTranslation("store.storeTip.chatSubHurt", _local_2);
                    }
                    else
                    {
                        if (EquipType.isEquip(_arg_1))
                        {
                            _local_2 = (StaticFormula.getDefenseAddition(int(_arg_1.Property7), _arg_1.StrengthenLevel) - StaticFormula.getDefenseAddition(int(_arg_1.Property7), (_arg_1.StrengthenLevel - 1)));
                            _local_3 = LanguageMgr.GetTranslation("store.storeTip.Armor", SPACING, SPACINGII, _local_2);
                            _local_4 = LanguageMgr.GetTranslation("store.storeTip.chatArmor", _local_2);
                        };
                    };
                };
            };
            this._lastTipString = (this._lastTipString + _local_3);
            return (_local_4);
        }

        private function showHoleTip(_arg_1:InventoryItemInfo):String
        {
            var _local_4:Array;
            var _local_5:int;
            this._changeTxtII.text = "";
            var _local_2:String = "";
            var _local_3:String = LanguageMgr.GetTranslation("store.storeTip.openHole");
            if (((_arg_1.CategoryID == EquipType.HEAD) || (_arg_1.CategoryID == EquipType.CLOTH)))
            {
                if ((((_arg_1.StrengthenLevel == 3) || (_arg_1.StrengthenLevel == 9)) || (_arg_1.StrengthenLevel == 12)))
                {
                    _local_3 = (_local_3 + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty")));
                };
                if (_arg_1.StrengthenLevel == 6)
                {
                    _local_3 = (_local_3 + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.clothOpenDefense")));
                };
            }
            else
            {
                if (_arg_1.CategoryID == EquipType.ARM)
                {
                    if ((((_arg_1.StrengthenLevel == 6) || (_arg_1.StrengthenLevel == 9)) || (_arg_1.StrengthenLevel == 12)))
                    {
                        _local_3 = (_local_3 + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty")));
                    };
                    if (_arg_1.StrengthenLevel == 3)
                    {
                        _local_3 = (_local_3 + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenAttack")));
                    };
                };
            };
            if (((((_arg_1.CategoryID == EquipType.HEAD) || (_arg_1.CategoryID == EquipType.CLOTH)) || (_arg_1.CategoryID == EquipType.ARM)) && ((((_arg_1.StrengthenLevel == 3) || (_arg_1.StrengthenLevel == 6)) || (_arg_1.StrengthenLevel == 9)) || (_arg_1.StrengthenLevel == 12))))
            {
                _local_4 = _arg_1.Hole.split("|");
                _local_5 = int((_arg_1.StrengthenLevel / 3));
                if (((_local_4[(_local_5 - 1)].split(",")[1] > 0) && (_arg_1[("Hole" + _local_5)] >= 0)))
                {
                    this._lastTipString = (this._lastTipString + ("\n" + _local_3));
                    return (_local_2);
                };
            };
            return (null);
        }

        private function showOpenHoleTip(_arg_1:InventoryItemInfo):String
        {
            var _local_2:String = LanguageMgr.GetTranslation("store.storeTip.openHole");
            return (_local_2 + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty")));
        }

        public function showSuccess(_arg_1:int=-1):void
        {
            this.removeTips();
            if (this.isDisplayerTip)
            {
                if ((!(this._moveSprite)))
                {
                    this._moveSprite = new Sprite();
                    addChild(this._moveSprite);
                };
                this._moveSprite.addChild(this._successBit);
                this.createTween();
            };
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("063", false, false);
            this._timer.start();
            switch (_arg_1)
            {
                case TRANSFER:
                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Transfer.Succes.ChatSay"));
                    return;
                case EMBED:
                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Embed.Succes.ChatSay"));
                    return;
                case COMPOSE:
                    ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Compose.Succes.ChatSay"));
                    return;
            };
        }

        public function showStrengthSuccess(_arg_1:InventoryItemInfo, _arg_2:Boolean):void
        {
            var _local_3:String;
            var _local_4:String;
            this._lastTipString = "";
            this.removeTips();
            if (this.isDisplayerTip)
            {
                if ((!(this._moveSprite)))
                {
                    this._moveSprite = new Sprite();
                    addChild(this._moveSprite);
                };
                this._moveSprite.addChild(this._successBit);
                _local_3 = this.showPropertyChange(_arg_1);
                _local_4 = ((_arg_2) ? this.showHoleTip(_arg_1) : null);
                if (_local_4)
                {
                    _local_3 = _local_3.replace("!", ",");
                    _local_3 = (_local_3 + _local_4);
                };
                this.createTween(this.strengthTweenComplete, [_local_3]);
                ChatManager.Instance.sysChatYellow((LanguageMgr.GetTranslation("store.Strength.Succes.ChatSay") + _local_3));
            };
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("063", false, false);
            this._timer.start();
        }

        private function strengthTweenComplete(_arg_1:String):void
        {
            if (_arg_1)
            {
                MessageTipManager.getInstance().show(_arg_1);
            };
            this.removeTips();
        }

        public function showEmbedSuccess(_arg_1:InventoryItemInfo):void
        {
            var _local_2:String;
            this._lastTipString = "";
            if (this.isDisplayerTip)
            {
                if ((!(this._moveSprite)))
                {
                    this._moveSprite = new Sprite();
                    addChild(this._moveSprite);
                };
                this._moveSprite.addChild(this._successBit);
                _local_2 = this.showOpenHoleTip(_arg_1);
                this.createTween(this.embedTweenComplete);
                this._lastTipString = _local_2;
                ChatManager.Instance.sysChatYellow((LanguageMgr.GetTranslation("store.Strength.Succes.ChatSay") + this._lastTipString));
            };
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("063", false, false);
            this._timer.start();
        }

        private function embedTweenComplete():void
        {
            MessageTipManager.getInstance().show(this._lastTipString);
            this.removeTips();
        }

        public function showFail():void
        {
            this.removeTips();
            if (this.isDisplayerTip)
            {
                if ((!(this._moveSprite)))
                {
                    this._moveSprite = new Sprite();
                    addChild(this._moveSprite);
                };
                this._moveSprite.addChild(this._failBit);
                this.createTween();
            };
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("064", false, false);
            this._timer.start();
        }

        public function showFiveFail():void
        {
            this.removeTips();
            if (this.isDisplayerTip)
            {
                if ((!(this._moveSprite)))
                {
                    this._moveSprite = new Sprite();
                    addChild(this._moveSprite);
                };
                this._moveSprite.addChild(this._failBit);
                this.createTween();
            };
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("064", false, false);
            this._timer.start();
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            this._timer.reset();
            SoundManager.instance.resumeMusic();
            SoundManager.instance.stop("063");
            SoundManager.instance.stop("064");
        }

        private function removeTips():void
        {
            if (((this._moveSprite) && (this._moveSprite.parent)))
            {
                while (this._moveSprite.numChildren)
                {
                    this._moveSprite.removeChildAt(0);
                };
                TweenMax.killTweensOf(this._moveSprite);
                this._moveSprite.parent.removeChild(this._moveSprite);
                this._moveSprite = null;
            };
        }

        public function dispose():void
        {
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
            this._timer.stop();
            this._timer = null;
            TweenMax.killTweensOf(this._moveSprite);
            SoundManager.instance.resumeMusic();
            SoundManager.instance.stop("063");
            SoundManager.instance.stop("064");
            this.removeTips();
            if (this._successBit)
            {
                ObjectUtils.disposeObject(this._successBit);
            };
            this._successBit = null;
            if (this._failBit)
            {
                ObjectUtils.disposeObject(this._failBit);
            };
            this._failBit = null;
            if (this._fiveFailBit)
            {
                ObjectUtils.disposeObject(this._fiveFailBit);
            };
            this._fiveFailBit = null;
            if (this._moveSprite)
            {
                ObjectUtils.disposeObject(this._moveSprite);
            };
            this._moveSprite = null;
            if (this._changeTxtI)
            {
                ObjectUtils.disposeObject(this._changeTxtI);
            };
            this._changeTxtI = null;
            if (this._changeTxtII)
            {
                ObjectUtils.disposeObject(this._changeTxtII);
            };
            this._changeTxtII = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store

