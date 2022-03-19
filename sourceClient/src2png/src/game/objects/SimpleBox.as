// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.SimpleBox

package game.objects
{
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.MovieClip;
    import phy.object.SmallObject;
    import flash.display.DisplayObjectContainer;
    import game.model.LocalPlayer;
    import game.GameManager;
    import game.view.smallMap.SmallBox;
    import phy.object.PhysicsLayer;
    import ddt.events.LivingEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import game.model.Living;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.ComponentFactory;
    import phy.object.PhysicalObj;
    import com.pickgliss.utils.ObjectUtils;

    public class SimpleBox extends SimpleObject 
    {

        private var _dieMC:MovieClipWrapper;
        private var _box:ScaleFrameImage;
        private var _ghostBox:MovieClip;
        private var _smallBox:SmallObject;
        private var _isGhostBox:Boolean;
        private var _subType:int = 0;
        private var _localVisible:Boolean = true;
        private var _constainer:DisplayObjectContainer;
        private var _self:LocalPlayer;
        private var _visible:Boolean = true;

        public function SimpleBox(_arg_1:int, _arg_2:String, _arg_3:int=1)
        {
            this._subType = _arg_3;
            this._self = GameManager.Instance.Current.selfGamePlayer;
            super(_arg_1, 1, _arg_2, "");
            this.x = x;
            this.y = y;
            _canCollided = true;
            if (this.isGhost)
            {
                setCollideRect(-8, -8, 16, 16);
            }
            else
            {
                setCollideRect(-15, -15, 30, 30);
            };
            this._smallBox = new SmallBox();
            this._isGhostBox = false;
            if (this.isGhost)
            {
                _canCollided = (this.visible = (!(this._self.isLiving)));
                this.smallView.visible = false;
            }
            else
            {
                this.smallView.visible = (_canCollided = (this.visible = this._self.isLiving));
            };
            this.addEvent();
        }

        override public function get smallView():SmallObject
        {
            return (this._smallBox);
        }

        override public function get layer():int
        {
            if (this._isGhostBox)
            {
                return (PhysicsLayer.GhostBox);
            };
            return (super.layer);
        }

        private function addEvent():void
        {
            if (this._self.isLiving)
            {
                this._self.addEventListener(LivingEvent.DIE, this.__onSelfPlayerDie);
            };
        }

        private function __click(_arg_1:MouseEvent):void
        {
            if (parent)
            {
                parent.setChildIndex(this, (parent.numChildren - 1));
            };
        }

        private function removeEvent():void
        {
            this._self.removeEventListener(LivingEvent.DIE, this.__onSelfPlayerDie);
            removeEventListener(MouseEvent.CLICK, this.__click);
            if (this._dieMC)
            {
                this._dieMC.removeEventListener(Event.COMPLETE, this.__boxDieComplete);
            };
        }

        public function get isGhost():Boolean
        {
            return (this._subType > 1);
        }

        public function get subType():int
        {
            return (this._subType);
        }

        public function get psychic():int
        {
            return (GhostBoxModel.getInstance().getPsychicByType(this._subType));
        }

        protected function setIsGhost(_arg_1:Boolean):void
        {
            if (_arg_1 == this._isGhostBox)
            {
                return;
            };
            this._isGhostBox = _arg_1;
            if ((!(this._isGhostBox)) == GameManager.Instance.Current.selfGamePlayer.isLiving)
            {
                this.visible = true;
            }
            else
            {
                this.visible = false;
            };
        }

        public function pickByLiving(_arg_1:Living):void
        {
            _arg_1.pick(this);
            if ((!(this._self.isLiving)))
            {
                SoundManager.instance.play("018");
            };
            this.die();
        }

        override protected function creatMovie(_arg_1:String):void
        {
            if (this.isGhost)
            {
                this._ghostBox = (ClassUtils.CreatInstance(("asset.game.GhostBox" + (this._subType - 1))) as MovieClip);
                this._ghostBox.mouseChildren = (this._ghostBox.mouseEnabled = false);
                this._ghostBox.visible = this.isGhost;
                this._ghostBox.x = (this._ghostBox.y = 4);
                this._ghostBox.gotoAndPlay("stand");
                addChild(this._ghostBox);
            }
            else
            {
                this._box = ComponentFactory.Instance.creatComponentByStylename("asset.game.simpleBoxPicAsset");
                this._box.x = (-(this._box.width) >> 1);
                this._box.y = (-(this._box.height) >> 1);
                this._box.setFrame(int(_arg_1));
                addChild(this._box);
            };
        }

        public function setContainer(_arg_1:DisplayObjectContainer):void
        {
            this._constainer = _arg_1;
            if (super.visible)
            {
                if (this.isGhost)
                {
                    if (((!(this._self.isLiving)) && (!(parent))))
                    {
                        this._constainer.addChild(this);
                    };
                }
                else
                {
                    this._constainer.addChild(this);
                };
            };
        }

        override public function set visible(_arg_1:Boolean):void
        {
            if ((!(this._self.isLiving)))
            {
                super.visible = ((_arg_1) && (this.isGhost));
            }
            else
            {
                super.visible = ((_arg_1) && (!(this.isGhost)));
            };
        }

        override public function collidedByObject(_arg_1:PhysicalObj):void
        {
            if ((_arg_1 is SimpleBomb))
            {
                SimpleBomb(_arg_1).owner.pick(this);
                if (((!(this.isGhost)) && (this._self.isLiving)))
                {
                    SoundManager.instance.play("018");
                };
                this.die();
            };
        }

        override public function die():void
        {
            var _local_1:MovieClip;
            if ((!(_isLiving)))
            {
                return;
            };
            _canCollided = false;
            if (visible)
            {
                if (this.isGhost)
                {
                    _local_1 = (ClassUtils.CreatInstance("asset.game.GhostBoxDie") as MovieClip);
                    if (((this._ghostBox) && (this._ghostBox.parent)))
                    {
                        this._ghostBox.stop();
                        this._ghostBox.parent.removeChild(this._ghostBox);
                    };
                }
                else
                {
                    _local_1 = (ClassUtils.CreatInstance("asset.game.pickBoxAsset") as MovieClip);
                    if (((this._box) && (this._box.parent)))
                    {
                        this._box.parent.removeChild(this._box);
                    };
                };
                this._dieMC = new MovieClipWrapper(_local_1, true, true);
                this._dieMC.addEventListener(Event.COMPLETE, this.__boxDieComplete);
                addChild(this._dieMC.movie);
                this.smallView.visible = false;
            };
            super.die();
        }

        protected function __boxDieComplete(_arg_1:Event):void
        {
            if (this._dieMC)
            {
                this._dieMC.removeEventListener(Event.COMPLETE, this.__boxDieComplete);
                this.dispose();
            };
        }

        override public function isBox():Boolean
        {
            return (true);
        }

        override public function get canCollided():Boolean
        {
            if (this.isGhost)
            {
                return (!(this._self.isLiving));
            };
            return (_canCollided);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._dieMC);
            this._dieMC = null;
            ObjectUtils.disposeObject(this._smallBox);
            this._smallBox = null;
            ObjectUtils.disposeObject(this._ghostBox);
            this._ghostBox = null;
            ObjectUtils.disposeObject(this._box);
            this._box = null;
            this._self = null;
            super.dispose();
        }

        override public function playAction(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case "BoxNormal":
                    this._box.visible = true;
                    this.setIsGhost(false);
                    return;
                case "BoxColorChanged":
                    if (this._box)
                    {
                        this._box.visible = false;
                    };
                    this.setIsGhost(true);
                    return;
                case "BoxColorRestored":
                    if (this._box)
                    {
                        this._box.visible = false;
                    };
                    this.setIsGhost(true);
                    return;
            };
        }

        public function __onSelfPlayerDie(_arg_1:Event):void
        {
            if ((!(this._self.isLast)))
            {
                this.visible = this.isGhost;
            };
        }


    }
}//package game.objects

