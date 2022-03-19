// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.buff.BuffCell

package game.view.buff
{
    import ddt.display.BitmapSprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import ddt.data.FightBuffInfo;
    import ddt.manager.BitmapManager;
    import ddt.view.tips.PropTxtTipInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.display.BitmapLoaderProxy;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.display.BitmapObject;
    import flash.geom.Matrix;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import consortion.data.ConsortionNewSkillInfo;
    import ddt.data.BuffType;
    import ddt.manager.PathManager;
    import flash.geom.Rectangle;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;
    import ddt.view.tips.BuffTipInfo;
    import ddt.data.FightConsotionBuff;

    public class BuffCell extends BitmapSprite implements ITipedDisplay 
    {

        private var _info:FightBuffInfo;
        private var _bitmapMgr:BitmapManager;
        private var _tipData:PropTxtTipInfo = new PropTxtTipInfo();
        private var _txt:FilterFrameText;
        private var _loaderProxy:BitmapLoaderProxy;

        public function BuffCell(_arg_1:BitmapObject=null, _arg_2:Matrix=null, _arg_3:Boolean=true, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_2, false, true);
            this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
            this._tipData = new PropTxtTipInfo();
            this._tipData.color = 0xF0F0F0;
            this._txt = ComponentFactory.Instance.creatComponentByStylename("game.petskillBuff.numTxt");
            addChild(this._txt);
        }

        override public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            if (this._loaderProxy)
            {
                this._loaderProxy.dispose();
            };
            this._loaderProxy = null;
            this._info = null;
            this._tipData = null;
            this._bitmapMgr.dispose();
            this._bitmapMgr = null;
            this._info = null;
            super.dispose();
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function clearSelf():void
        {
            ShowTipManager.Instance.removeTip(this);
            if (parent)
            {
                parent.removeChild(this);
            };
            if (this._loaderProxy)
            {
                this._loaderProxy.dispose();
            };
            this._loaderProxy = null;
            clearBitmap();
            ObjectUtils.disposeObject(bitmapObject);
            bitmapObject = null;
            this._info = null;
        }

        public function setInfo(_arg_1:FightBuffInfo):void
        {
            var _local_2:ConsortionNewSkillInfo;
            if (this._loaderProxy)
            {
                this._loaderProxy.dispose();
            };
            this._loaderProxy = null;
            clearBitmap();
            ObjectUtils.disposeObject(bitmapObject);
            bitmapObject = null;
            this._info = _arg_1;
            this._tipData.property = this._info.buffName;
            this._tipData.detail = this._info.description;
            if (_arg_1.type == BuffType.PET_BUFF)
            {
                this._loaderProxy = new BitmapLoaderProxy(PathManager.solvePetBuff(_arg_1.buffPic), new Rectangle(0, 0, 32, 32));
                addChild(this._loaderProxy);
                ShowTipManager.Instance.addTip(this);
            }
            else
            {
                if (((_arg_1.type == BuffType.CONSORTIA) && ((PlayerManager.Instance.Self.consortionStatus) || (!(_arg_1.isSelf)))))
                {
                    _local_2 = ConsortionModelControl.Instance.model.getInfoByType(_arg_1.id);
                    if (_local_2)
                    {
                        this._loaderProxy = new BitmapLoaderProxy(PathManager.solveConsortionBuff(_local_2.Pic), new Rectangle(0, 0, 32, 32));
                        addChild(this._loaderProxy);
                        ShowTipManager.Instance.addTip(this);
                    };
                }
                else
                {
                    if (_arg_1.type == BuffType.MILITARY_BUFF)
                    {
                        bitmapObject = this._bitmapMgr.getBitmap("asset.game.buff14");
                    }
                    else
                    {
                        if (_arg_1.displayid != 101)
                        {
                            bitmapObject = this._bitmapMgr.getBitmap(("asset.game.buff" + this._info.displayid));
                        };
                    };
                };
            };
            if (_arg_1.displayid == BuffType.ARENA_MARS)
            {
                ShowTipManager.Instance.addTip(this);
            };
            if (this._info.Count > 1)
            {
                addChild(this._txt);
                this._txt.text = this._info.Count.toString();
            }
            else
            {
                if (contains(this._txt))
                {
                    removeChild(this._txt);
                };
            };
            if (((BuffType.isLocalBuffByID(this._info.id)) || (BuffType.isContainerBuff(this._info))))
            {
                ShowTipManager.Instance.addTip(this);
            };
        }

        public function get tipData():Object
        {
            var _local_2:BuffTipInfo;
            var _local_1:FightConsotionBuff = new FightConsotionBuff(this._info);
            if (BuffType.isContainerBuff(this._info))
            {
                return (_local_1.tipData);
            };
            if (((BuffType.isMilitaryBuff(this._info.id)) || (BuffType.isArenaBufferByID(this._info.id))))
            {
                _local_2 = new BuffTipInfo();
                _local_2.name = this._info.buffName;
                _local_2.describe = this._info.description;
                return (_local_2);
            };
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
        }

        public function get tipDirctions():String
        {
            return ("7,6,5,1,6,4");
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (6);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (6);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            if ((((BuffType.isContainerBuff(this._info)) || (BuffType.isMilitaryBuff(this._info.id))) || (BuffType.isArenaBufferByID(this._info.id))))
            {
                return ("core.PayBuffTip");
            };
            return ("core.FightBuffTip");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }


    }
}//package game.view.buff

