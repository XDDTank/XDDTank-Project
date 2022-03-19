// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StoreStrengthProgress

package store.view.strength
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import store.events.StoreIIEvent;
    import ddt.manager.ItemManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class StoreStrengthProgress extends Component 
    {

        protected var _background:Bitmap;
        protected var _thuck:Component;
        protected var _graphics_thuck:Bitmap;
        protected var _progressLabel:FilterFrameText;
        protected var _star:MovieClip;
        protected var _max:Number = 0;
        protected var _currentFrame:int;
        protected var _strengthenLevel:int;
        protected var _strengthenExp:int;
        protected var _progressBarMask:Sprite;
        protected var _scaleValue:Number;
        protected var _taskFrames:Dictionary;
        protected var _total:int = 50;

        public function StoreStrengthProgress()
        {
            this.initView();
        }

        protected function initView():void
        {
            this._background = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StrengthenSpaceProgress");
            PositionUtils.setPos(this._background, "asset.ddtstore.StrengthenSpaceProgressBgPos");
            addChild(this._background);
            this._thuck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.thunck");
            addChild(this._thuck);
            this._graphics_thuck = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StrengthenColorStrip");
            addChild(this._graphics_thuck);
            this.initMask();
            this._star = ClassUtils.CreatInstance("asset.strengthen.star");
            this._star.y = (this._progressBarMask.y + (this._progressBarMask.height / 2));
            addChild(this._star);
            this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.StoreStrengthProgressText");
            addChild(this._progressLabel);
            this._scaleValue = (this._graphics_thuck.width / this._total);
            this.resetProgress();
        }

        protected function startProgress():void
        {
            this.addEventListener(Event.ENTER_FRAME, this.__startFrame);
        }

        protected function __startFrame(_arg_1:Event):void
        {
            this.setMask(this._currentFrame);
            this._currentFrame++;
            var _local_2:int;
            if (this._taskFrames.hasOwnProperty(0))
            {
                _local_2 = this._taskFrames[0];
            };
            if (((_local_2 == 0) && (this._taskFrames.hasOwnProperty(1))))
            {
                _local_2 = this._taskFrames[1];
            };
            if (this._currentFrame >= _local_2)
            {
                if (_local_2 >= this._total)
                {
                    this._currentFrame = 0;
                    this._taskFrames[0] = 0;
                    this.dispatchEvent(new Event(StoreIIEvent.UPGRADES_PLAY));
                }
                else
                {
                    this._taskFrames[1] = 0;
                    this.removeEventListener(Event.ENTER_FRAME, this.__startFrame);
                    this.setStarVisible(false);
                    _arg_1.stopImmediatePropagation();
                };
            };
        }

        protected function initMask():void
        {
            this._progressBarMask = new Sprite();
            this._progressBarMask.graphics.beginFill(0xFFFFFF, 1);
            this._progressBarMask.graphics.drawRect(-6, 0, this._graphics_thuck.width, this._graphics_thuck.height);
            this._progressBarMask.graphics.endFill();
            this._progressBarMask.x = -5;
            this._progressBarMask.y = -5;
            this._graphics_thuck.cacheAsBitmap = true;
            this._graphics_thuck.mask = this._progressBarMask;
            addChild(this._progressBarMask);
        }

        protected function setStarVisible(_arg_1:Boolean):void
        {
            this._star.visible = _arg_1;
        }

        public function getStarVisible():Boolean
        {
            return (this._star.visible);
        }

        public function setMask(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 * this._scaleValue);
            if (((isNaN(_local_2)) || (_local_2 == 0)))
            {
                this._progressBarMask.width = 0;
            }
            else
            {
                if (_local_2 >= this._graphics_thuck.width)
                {
                    _local_2 = (_local_2 % this._graphics_thuck.width);
                };
                this._progressBarMask.width = _local_2;
            };
            this._star.x = (this._progressBarMask.x + this._progressBarMask.width);
        }

        public function initProgress(_arg_1:InventoryItemInfo):void
        {
            var _local_3:Number;
            var _local_4:int;
            this._currentFrame = 0;
            this._strengthenExp = _arg_1.StrengthenExp;
            this._strengthenLevel = _arg_1.StrengthenLevel;
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            this._max = ItemManager.Instance.getEquipStrengthInfoByLevel((this._strengthenLevel + 1), _local_2.QualityID).Exp;
            if (((this._max > 0) && (this._strengthenExp < this._max)))
            {
                _local_3 = (this._strengthenExp / this._max);
                _local_4 = Math.floor((_local_3 * this._total));
                if (((_local_4 < 1) && (_local_3 > 0)))
                {
                    _local_4 = 1;
                };
                this._currentFrame = _local_4;
            };
            this.setMask(this._currentFrame);
            this.setExpPercent(_arg_1);
            this._taskFrames = new Dictionary();
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, this.__startFrame);
            };
            this.setStarVisible(false);
        }

        public function setProgress(_arg_1:InventoryItemInfo):void
        {
            if (this._strengthenLevel != _arg_1.StrengthenLevel)
            {
                this._taskFrames[0] = this._total;
                this._strengthenLevel = _arg_1.StrengthenLevel;
            };
            this._strengthenExp = _arg_1.StrengthenExp;
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            if (ItemManager.Instance.getEquipStrengthInfoByLevel((this._strengthenLevel + 1), _local_2.QualityID))
            {
                this._max = ItemManager.Instance.getEquipStrengthInfoByLevel((this._strengthenLevel + 1), _local_2.QualityID).Exp;
            }
            else
            {
                this._max = 0;
            };
            var _local_3:Number = (this._strengthenExp / this._max);
            var _local_4:int = Math.floor((_local_3 * this._total));
            if (((_local_4 < 1) && (_local_3 > 0)))
            {
                _local_4 = 1;
            };
            if (this._currentFrame == _local_4)
            {
                if (((this._taskFrames[0]) && (!(int(this._taskFrames[0]) == 0))))
                {
                    this.setStarVisible(true);
                    this._taskFrames[1] = _local_4;
                    this.startProgress();
                };
            }
            else
            {
                this.setStarVisible(true);
                this._taskFrames[1] = _local_4;
                this.startProgress();
            };
            this.setExpPercent(_arg_1);
        }

        public function setExpPercent(_arg_1:InventoryItemInfo=null):void
        {
            var _local_2:Number;
            if (this._strengthenExp == 0)
            {
                this._progressLabel.text = "0%";
            }
            else
            {
                _local_2 = (Math.floor(((this._strengthenExp / this._max) * 10000)) / 100);
                if (isNaN(_local_2))
                {
                    _local_2 = 0;
                };
                this._progressLabel.text = (_local_2 + "%");
            };
            if (((_arg_1) && (this._strengthenLevel >= ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID).StrengthLimit)))
            {
                tipData = "0/0";
            }
            else
            {
                if (isNaN(this._strengthenExp))
                {
                    this._strengthenExp = 0;
                };
                if (isNaN(this._max))
                {
                    this._max = 0;
                };
                tipData = ((this._strengthenExp + "/") + this._max);
            };
        }

        public function resetProgress():void
        {
            tipData = "0/0";
            this._progressLabel.text = "0%";
            this._strengthenExp = 0;
            this._max = 0;
            this._currentFrame = 0;
            this._strengthenLevel = -1;
            this.setMask(0);
            this.setStarVisible(false);
            this._taskFrames = new Dictionary();
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._graphics_thuck);
            this._graphics_thuck = null;
            ObjectUtils.disposeObject(this._background);
            this._background = null;
            ObjectUtils.disposeObject(this._thuck);
            this._thuck = null;
            ObjectUtils.disposeObject(this._progressLabel);
            this._progressLabel = null;
            if (this._progressBarMask)
            {
                ObjectUtils.disposeObject(this._progressBarMask);
            };
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, this.__startFrame);
            };
            super.dispose();
        }


    }
}//package store.view.strength

