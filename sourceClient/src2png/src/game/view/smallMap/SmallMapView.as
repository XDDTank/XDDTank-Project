// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.SmallMapView

package game.view.smallMap
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import game.view.map.MapView;
    import ddt.data.map.MissionInfo;
    import flash.utils.Dictionary;
    import road7th.data.DictionaryData;
    import flash.geom.Rectangle;
    import com.pickgliss.toplevel.StageReferance;
    import room.RoomManager;
    import com.pickgliss.ui.ComponentFactory;
    import game.GameManager;
    import flash.display.Graphics;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import flash.utils.setTimeout;
    import flash.display.BlendMode;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import game.animations.AnimationSet;
    import game.animations.DragMapAnimation;
    import game.animations.AnimationLevel;
    import phy.object.SmallObject;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import game.model.LocalPlayer;
    import game.model.Living;
    import game.model.Player;
    import __AS3__.vec.Vector;
    import game.objects.GamePlayer;

    public class SmallMapView extends Sprite implements Disposeable 
    {

        private static const NUMBERS_ARR:Array = ["tank.game.smallmap.ShineNumber1", "tank.game.smallmap.ShineNumber2", "tank.game.smallmap.ShineNumber3", "tank.game.smallmap.ShineNumber4", "tank.game.smallmap.ShineNumber5", "tank.game.smallmap.ShineNumber6", "tank.game.smallmap.ShineNumber7", "tank.game.smallmap.ShineNumber8", "tank.game.smallmap.ShineNumber9"];
        public static var MAX_WIDTH:Number = 165;
        public static var MIN_WIDTH:Number = 120;
        public static const HARD_LEVEL:Array = [LanguageMgr.GetTranslation("tank.game.smallmap.simple"), LanguageMgr.GetTranslation("tank.game.smallmap.normal"), LanguageMgr.GetTranslation("tank.game.smallmap.difficulty"), LanguageMgr.GetTranslation("tank.game.smallmap.hero")];
        public static const HARD_LEVEL1:Array = [LanguageMgr.GetTranslation("tank.game.smallmap.simple1"), LanguageMgr.GetTranslation("tank.game.smallmap.normal1"), LanguageMgr.GetTranslation("tank.game.smallmap.difficulty1")];

        private var _screen:Sprite;
        private var _foreMap:Sprite;
        private var _thingLayer:Sprite;
        private var _mapBorder:Sprite;
        private var _hardTxt:FilterFrameText;
        private var _line:Sprite;
        private var _smallMapContainerBg:Sprite;
        private var _mask:Shape;
        private var _foreMapMask:Shape;
        private var _changeScale:Number = 0.2;
        private var _allowDrag:Boolean = true;
        private var _split:Sprite;
        private var _texts:Array;
        private var _screenMask:Sprite;
        private var _processer:ThingProcesser;
        private var _drawMatrix:Matrix = new Matrix();
        private var _lineRef:BitmapData;
        private var _foreground:Shape;
        private var _dragScreen:Sprite;
        private var _titleBar:SmallMapTitleBar;
        private var _Screen_X:Number;
        private var _Screen_Y:Number;
        private var _mapBmp:Bitmap;
        private var _mapDeadBmp:Bitmap;
        private var _rateX:Number;
        private var _map:MapView;
        private var _rateY:Number;
        private var _missionInfo:MissionInfo;
        private var _w:Number;
        private var _h:Number;
        private var _groundShape:Sprite;
        private var _beadShape:Shape;
        private var _startDrag:Boolean = false;
        private var _child:Dictionary = new Dictionary();
        private var _update:Boolean;
        private var _allLivings:DictionaryData;
        private var _collideRect:Rectangle = new Rectangle(-45, -30, 100, 80);
        private var _drawRoute:Sprite;

        public function SmallMapView(_arg_1:MapView, _arg_2:MissionInfo)
        {
            this._map = _arg_1;
            this._missionInfo = _arg_2;
            this._processer = new ThingProcesser();
            this.initView();
            this.initEvent();
        }

        public function set allowDrag(_arg_1:Boolean):void
        {
            this._allowDrag = _arg_1;
            if ((!(this._allowDrag)))
            {
                this.__mouseUp(null);
            };
            this._screen.mouseChildren = (this._screen.mouseEnabled = this._allowDrag);
        }

        public function get rateX():Number
        {
            return (this._rateX);
        }

        public function get rateY():Number
        {
            return (this._rateY);
        }

        public function get smallMapW():Number
        {
            return (this._mask.width);
        }

        public function get smallMapH():Number
        {
            return (this._mask.height);
        }

        public function setHardLevel(_arg_1:int, _arg_2:int=0):void
        {
            if (_arg_2 == 0)
            {
                this._titleBar.title = HARD_LEVEL[_arg_1];
            }
            else
            {
                this._titleBar.title = HARD_LEVEL1[_arg_1];
            };
        }

        public function setBarrier(_arg_1:int, _arg_2:int):void
        {
            this._titleBar.setBarrier(_arg_1, _arg_2);
        }

        private function initView():void
        {
            this._drawMatrix.a = (this._drawMatrix.d = (96 / this._map.bound.height));
            this._w = (this._drawMatrix.a * this._map.bound.width);
            this._h = (this._drawMatrix.d * this._map.bound.height);
            if (this._w > 240)
            {
                this._w = 240;
                this._drawMatrix.a = (this._drawMatrix.d = (240 / this._map.bound.width));
                this._h = (this._drawMatrix.d * this._map.bound.height);
            };
            this._groundShape = new Sprite();
            addChild(this._groundShape);
            this._beadShape = new Shape();
            addChild(this._beadShape);
            this._screen = new DragScreen((StageReferance.stageWidth * this._drawMatrix.a), (StageReferance.stageHeight * this._drawMatrix.d));
            addChild(this._screen);
            this._thingLayer = new Sprite();
            this._thingLayer.mouseChildren = (this._thingLayer.mouseEnabled = false);
            addChild(this._thingLayer);
            this._foreground = new Shape();
            addChild(this._foreground);
            this._titleBar = new SmallMapTitleBar(this._missionInfo);
            this._titleBar.width = this._w;
            this._titleBar.y = -24;
            y = 25;
            if (RoomManager.Instance.current.canShowTitle())
            {
                this._titleBar.title = HARD_LEVEL[RoomManager.Instance.current.hardLevel];
            }
            else
            {
                this._titleBar.title = "";
            };
            addChild(this._titleBar);
            this._lineRef = ComponentFactory.Instance.creatBitmapData("asset.game.lineAsset");
            this._allLivings = GameManager.Instance.Current.livings;
            this.drawBackground();
            this.drawForeground();
            this.updateSpliter();
            this._drawRoute = new Sprite();
            addChild(this._drawRoute);
        }

        public function get __StartDrag():Boolean
        {
            return (this._startDrag);
        }

        private function drawBackground():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(this._lineRef);
            _local_1.drawRect(0, 0, this._w, this._h);
            _local_1.endFill();
            this._thingLayer.scrollRect = new Rectangle(0, 0, this._w, this._h);
            _local_1 = this._thingLayer.graphics;
            _local_1.clear();
            _local_1.beginFill(0, 0);
            _local_1.drawRect(0, 0, this._w, this._h);
            _local_1.endFill();
        }

        private function drawForeground():void
        {
            var _local_1:Graphics = this._foreground.graphics;
            _local_1.clear();
            _local_1.lineStyle(1, 0x666666);
            _local_1.beginFill(0, 0);
            _local_1.drawRect(0, 0, this._w, this._h);
            _local_1.endFill();
        }

        public function get foreMap():Sprite
        {
            return (this);
        }

        private function updateSpliter():void
        {
            var _local_3:MovieClip;
            if (this._split == null)
            {
                return;
            };
            while (this._split.numChildren > 0)
            {
                this._split.removeChildAt(0);
            };
            this._texts = [];
            var _local_1:Number = (this._screen.width / 10);
            this._split.graphics.clear();
            this._split.graphics.lineStyle(1, 0xFFFFFF, 1);
            var _local_2:int = 1;
            while (_local_2 < 10)
            {
                this._split.graphics.moveTo((_local_1 * _local_2), 0);
                this._split.graphics.lineTo((_local_1 * _local_2), this._screen.height);
                _local_3 = ClassUtils.CreatInstance(NUMBERS_ARR[(_local_2 - 1)]);
                _local_3.x = (_local_1 * _local_2);
                _local_3.y = ((this._screen.height - _local_3.height) / 2);
                _local_3.stop();
                this._split.addChild(_local_3);
                this._texts.push(_local_3);
                _local_2++;
            };
            this._split.graphics.endFill();
        }

        public function ShineText(_arg_1:int):void
        {
            this.large();
            this.drawMask();
            var _local_2:int;
            while (_local_2 < _arg_1)
            {
                setTimeout(this.shineText, (_local_2 * 1500), _local_2);
                _local_2++;
            };
        }

        private function drawMask():void
        {
            var _local_1:Rectangle;
            var _local_2:Sprite;
            if (this._screenMask == null)
            {
                _local_1 = getBounds(parent);
                this._screenMask = new Sprite();
                this._screenMask.graphics.beginFill(0, 0.8);
                this._screenMask.graphics.drawRect(0, 0, StageReferance.stageWidth, StageReferance.stageHeight);
                this._screenMask.graphics.endFill();
                this._screenMask.blendMode = BlendMode.LAYER;
                _local_2 = new Sprite();
                _local_2.graphics.beginFill(0, 1);
                _local_2.graphics.drawRect(0, 0, _local_1.width, _local_1.height);
                _local_2.graphics.endFill();
                _local_2.x = this.x;
                _local_2.y = _local_1.top;
                _local_2.blendMode = BlendMode.ERASE;
                this._screenMask.addChild(_local_2);
            };
            LayerManager.Instance.addToLayer(this._screenMask, LayerManager.GAME_DYNAMIC_LAYER);
        }

        private function clearMask():void
        {
            if (((this._screenMask) && (this._screenMask.parent)))
            {
                this._screenMask.parent.removeChild(this._screenMask);
            };
        }

        private function large():void
        {
            scaleX = (scaleY = 3);
            x = ((StageReferance.stageWidth - width) >> 1);
            y = ((StageReferance.stageHeight - height) >> 1);
        }

        public function restore():void
        {
            scaleX = (scaleY = 1);
            x = ((StageReferance.stageWidth - this.realWidth) - 1);
            y = 25;
            this.clearMask();
        }

        public function restoreText():void
        {
            var _local_1:MovieClip;
            for each (_local_1 in this._texts)
            {
                _local_1.gotoAndStop(1);
            };
        }

        private function shineText(_arg_1:int):void
        {
            this.restoreText();
            if (this._split == null)
            {
                this._split = new Sprite();
                this._split.mouseChildren = (this._split.mouseEnabled = false);
                addChild(this._split);
                this.updateSpliter();
            };
            if (_arg_1 > 4)
            {
                (this._texts[4] as MovieClip).play();
            }
            else
            {
                (this._texts[_arg_1] as MovieClip).play();
            };
        }

        public function showSpliter():void
        {
            if (this._split == null)
            {
                this._split = new Sprite();
                this._split.mouseChildren = (this._split.mouseEnabled = false);
                addChild(this._split);
                this.updateSpliter();
            };
            this._split.visible = true;
        }

        public function hideSpliter():void
        {
            if (this._split != null)
            {
                this._split.visible = false;
            };
        }

        private function initEvent():void
        {
            this._groundShape.addEventListener(MouseEvent.MOUSE_DOWN, this.__click);
            this._screen.addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
        }

        private function removeEvents():void
        {
            this._groundShape.removeEventListener(MouseEvent.MOUSE_DOWN, this.__click);
            this._screen.removeEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
        }

        private function __mouseDown(_arg_1:MouseEvent):void
        {
            this._map.lockOwner = -1;
            this._screen.y = this._screen.y;
            this._Screen_X = this._screen.x;
            this._Screen_Y = this._screen.y;
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            addEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
            var _local_2:Rectangle = getBounds(this);
            _local_2.top = 0;
            _local_2.right = (_local_2.right - this._screen.width);
            _local_2.bottom = (_local_2.bottom - this._screen.height);
            this._screen.startDrag(false, _local_2);
            this._startDrag = true;
        }

        private function __mouseUp(_arg_1:MouseEvent):void
        {
            this._map.lockOwner = AnimationSet.PUBLIC_OWNER;
            this._startDrag = false;
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__mouseUp);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__mouseMove);
            removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
            this._screen.stopDrag();
        }

        public function get realWidth():Number
        {
            return (this._groundShape.width);
        }

        public function get screen():Sprite
        {
            return (this._screen);
        }

        public function get screenX():int
        {
            return (this._Screen_X);
        }

        public function get screenY():int
        {
            return (this._Screen_Y);
        }

        private function __mouseMove(_arg_1:MouseEvent):void
        {
        }

        private function __onEnterFrame(_arg_1:Event):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (this._startDrag)
            {
                this._screen.y = this._screen.y;
                this._screen.x = ((this._screen.x < 0) ? 0 : this._screen.x);
                _local_2 = ((this._screen.x + (this._screen.width / 2)) / this._drawMatrix.a);
                _local_3 = ((this._screen.y + (this._screen.height / 2)) / this._drawMatrix.d);
                this._map.animateSet.addAnimation(new DragMapAnimation(_local_2, _local_3, true, 100, AnimationLevel.HIGHEST, AnimationSet.PUBLIC_OWNER));
                if (this._split)
                {
                    this._split.x = this._screen.x;
                    this._split.y = this._screen.y;
                };
            };
        }

        public function update():void
        {
            this.draw(true);
            this.drawDead(true);
            this.updateSpliter();
            if (this._split != null)
            {
                this._split.x = this._screen.x;
                this._split.y = this._screen.y;
            };
        }

        private function drawDead(_arg_1:Boolean=false):void
        {
            if (((!(this._map.mapChanged)) && (!(_arg_1))))
            {
                return;
            };
            if ((!(this._map.stone)))
            {
                return;
            };
            var _local_2:Graphics = this._beadShape.graphics;
            _local_2.clear();
            _local_2.beginBitmapFill(this._map.stone.bitmapData, this._drawMatrix, false, true);
            _local_2.drawRect(0, 0, this._w, this._h);
            _local_2.endFill();
        }

        public function draw(_arg_1:Boolean=false):void
        {
            if (((!(this._map.mapChanged)) && (!(_arg_1))))
            {
                return;
            };
            var _local_2:Graphics = this._groundShape.graphics;
            _local_2.clear();
            if ((!(this._map.ground)))
            {
                _local_2.beginFill(0, 0);
            }
            else
            {
                _local_2.beginBitmapFill(this._map.ground.bitmapData, this._drawMatrix, false, true);
            };
            _local_2.drawRect(0, 0, this._w, this._h);
            _local_2.endFill();
        }

        public function setScreenPos(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Rectangle;
            if ((!(this._startDrag)))
            {
                _local_3 = Math.abs((_arg_1 * this._drawMatrix.a));
                _local_4 = Math.abs((_arg_2 * this._drawMatrix.d));
                _local_5 = this._screen.getBounds(this);
                if ((_local_3 + this._screen.width) >= this._w)
                {
                    this._screen.x = (this._w - this._screen.width);
                }
                else
                {
                    if (_local_3 < 0)
                    {
                        this._screen.x = 0;
                    }
                    else
                    {
                        this._screen.x = _local_3;
                    };
                };
                if ((_local_4 + this._screen.height) >= this._h)
                {
                    this._screen.y = ((this._h - this._screen.height) - 9);
                }
                else
                {
                    if (_local_4 < 0)
                    {
                        this._screen.y = 9;
                    }
                    else
                    {
                        this._screen.y = _local_4;
                    };
                };
                if (this._split != null)
                {
                    this._split.x = this._screen.x;
                    this._split.y = this._screen.y;
                };
            };
        }

        public function addObj(_arg_1:SmallObject):void
        {
            if ((!(_arg_1.onProcess)))
            {
                this.addAnimation(_arg_1);
            };
            this._thingLayer.addChild(_arg_1);
        }

        public function removeObj(_arg_1:SmallObject):void
        {
            if (_arg_1.parent == this._thingLayer)
            {
                this._thingLayer.removeChild(_arg_1);
                if (_arg_1.onProcess)
                {
                    this.removeAnimation(_arg_1);
                };
            };
        }

        public function updatePos(_arg_1:SmallObject, _arg_2:Point):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            _arg_1.x = (_arg_2.x * this._drawMatrix.a);
            _arg_1.y = (_arg_2.y * this._drawMatrix.d);
            this._thingLayer.addChild(_arg_1);
        }

        public function addAnimation(_arg_1:SmallObject):void
        {
            this._processer.addThing(_arg_1);
        }

        public function removeAnimation(_arg_1:SmallObject):void
        {
            this._processer.removeThing(_arg_1);
        }

        public function dispose():void
        {
            this.removeEvents();
            this._missionInfo = null;
            if (this._titleBar)
            {
                ObjectUtils.disposeObject(this._titleBar);
                this._titleBar = null;
            };
            if (this._mapBmp)
            {
                if (this._mapBmp.parent)
                {
                    this._mapBmp.parent.removeChild(this._mapBmp);
                };
                if (this._mapBmp.bitmapData)
                {
                    this._mapBmp.bitmapData.dispose();
                };
            };
            this._mapBmp = null;
            if (this._mapDeadBmp)
            {
                if (this._mapDeadBmp.parent)
                {
                    this._mapDeadBmp.parent.removeChild(this._mapDeadBmp);
                };
                if (this._mapDeadBmp.bitmapData)
                {
                    this._mapDeadBmp.bitmapData.dispose();
                };
            };
            this._mapDeadBmp = null;
            if (this._line)
            {
                ObjectUtils.disposeAllChildren(this._line);
                if (this._line.parent)
                {
                    this._line.parent.removeChild(this._line);
                };
                this._line = null;
            };
            if (this._screen)
            {
                ObjectUtils.disposeAllChildren(this._screen);
                if (this._screen.parent)
                {
                    this._screen.parent.removeChild(this._screen);
                };
                this._screen = null;
            };
            if (this._smallMapContainerBg)
            {
                ObjectUtils.disposeAllChildren(this._smallMapContainerBg);
                if (this._smallMapContainerBg.parent)
                {
                    this._smallMapContainerBg.parent.removeChild(this._smallMapContainerBg);
                };
                this._smallMapContainerBg = null;
            };
            if (this._split)
            {
                ObjectUtils.disposeAllChildren(this._split);
                if (this._split)
                {
                    this._split.parent.removeChild(this._split);
                };
                this._split = null;
            };
            if (this._mapBorder)
            {
                ObjectUtils.disposeAllChildren(this._mapBorder);
                if (this._mapBorder.parent)
                {
                    this._mapBorder.parent.removeChild(this._mapBorder);
                };
                this._mapBorder = null;
            };
            if (this._map.parent)
            {
                this._map.parent.removeChild(this._map);
            };
            this._map = null;
            ObjectUtils.disposeAllChildren(this);
            if (this._lineRef)
            {
                this._lineRef.dispose();
                this._lineRef = null;
            };
            this._processer.dispose();
            this._processer = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function __largeMap(_arg_1:MouseEvent):void
        {
            this._changeScale = 0.2;
            var _local_2:Number = this._rateX;
            var _local_3:Number = this._rateY;
            this.update();
            this.updateChildPos(_local_2, _local_3);
            SoundManager.instance.play("008");
        }

        private function __smallMap(_arg_1:MouseEvent):void
        {
            this._changeScale = -0.2;
            var _local_2:Number = this._rateX;
            var _local_3:Number = this._rateY;
            this.update();
            this.updateChildPos(_local_2, _local_3);
            SoundManager.instance.play("008");
        }

        private function updateChildPos(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:Sprite;
            for each (_local_3 in this._child)
            {
                _local_3.x = ((_local_3.x / _arg_1) * this._rateX);
                _local_3.y = ((_local_3.y / _arg_2) * this._rateY);
            };
        }

        private function __click(_arg_1:MouseEvent):void
        {
            if (this._allowDrag)
            {
                this._map.animateSet.addAnimation(new DragMapAnimation((_arg_1.localX / this._drawMatrix.a), (_arg_1.localY / this._drawMatrix.d), false, 100, AnimationLevel.HIGHEST, AnimationSet.PUBLIC_OWNER));
            };
        }

        public function moveToPlayer():void
        {
            var _local_1:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
            var _local_2:Number = _local_1.pos.x;
            var _local_3:Number = ((this._screen.y + (this._screen.height / 2)) / this._drawMatrix.d);
            this._map.animateSet.addAnimation(new DragMapAnimation(_local_2, _local_3, true, 100, AnimationLevel.HIGHER, AnimationSet.PUBLIC_OWNER));
        }

        public function get titleBar():SmallMapTitleBar
        {
            return (this._titleBar);
        }

        public function set enableExit(_arg_1:Boolean):void
        {
            this._titleBar.enableExit = _arg_1;
        }

        public function drawRouteLine(_arg_1:int):void
        {
            var _local_2:Living;
            this._drawRoute.graphics.clear();
            for each (_local_2 in this._allLivings)
            {
                _local_2.currentSelectId = _arg_1;
            };
            if (_arg_1 < 0)
            {
                return;
            };
            var _local_3:Player = GameManager.Instance.Current.findPlayer(_arg_1);
            if ((!(_local_3)))
            {
                return;
            };
            var _local_4:Vector.<Point> = _local_3.route;
            if (((!(_local_4)) || (_local_4.length == 0)))
            {
                return;
            };
            var _local_5:GamePlayer = (this._map.getPhysical(_arg_1) as GamePlayer);
            this._collideRect.x = ((_local_5.pos.x * this._drawMatrix.a) - (50 * this._drawMatrix.a));
            this._collideRect.y = ((_local_5.pos.y * this._drawMatrix.d) - (50 * this._drawMatrix.d));
            this._drawRoute.graphics.lineStyle(1, 0xFF0000, 1);
            var _local_6:int = _local_4.length;
            var _local_7:int;
            while (_local_7 < (_local_6 - 1))
            {
                this.drawDashed(this._drawRoute.graphics, _local_4[_local_7], _local_4[(_local_7 + 1)], 8, 5);
                _local_7++;
            };
        }

        private function drawDashed(_arg_1:Graphics, _arg_2:Point, _arg_3:Point, _arg_4:Number, _arg_5:Number):void
        {
            var _local_11:Number;
            var _local_12:Number;
            if ((((((!(_arg_1)) || (!(_arg_2))) || (!(_arg_3))) || (_arg_4 <= 0)) || (_arg_5 <= 0)))
            {
                return;
            };
            var _local_6:Number = (_arg_2.x * this._drawMatrix.a);
            var _local_7:Number = (_arg_2.y * this._drawMatrix.d);
            var _local_8:Number = Math.atan2(((_arg_3.y * this._drawMatrix.d) - _local_7), ((_arg_3.x * this._drawMatrix.a) - _local_6));
            var _local_9:Number = 0.5;
            var _local_10:Number = 0;
            while (_local_10 <= _local_9)
            {
                if (this._collideRect.contains(_local_11, _local_12))
                {
                    return;
                };
                _local_11 = (_local_6 + (Math.cos(_local_8) * _local_10));
                _local_12 = (_local_7 + (Math.sin(_local_8) * _local_10));
                _arg_1.moveTo(_local_11, _local_12);
                _local_10 = (_local_10 + _arg_4);
                if (_local_10 > _local_9)
                {
                    _local_10 = _local_9;
                };
                _local_11 = (_local_6 + (Math.cos(_local_8) * _local_10));
                _local_12 = (_local_7 + (Math.sin(_local_8) * _local_10));
                _arg_1.lineTo(_local_11, _local_12);
                _local_10 = (_local_10 + _arg_5);
            };
        }


    }
}//package game.view.smallMap

import __AS3__.vec.Vector;
import phy.object.SmallObject;
import flash.utils.getTimer;
import com.pickgliss.toplevel.StageReferance;
import flash.events.Event;
import __AS3__.vec.*;

class ThingProcesser 
{

    /*private*/ var _objectList:Vector.<SmallObject> = new Vector.<SmallObject>();
    /*private*/ var _startuped:Boolean = false;
    /*private*/ var _lastTime:int = 0;


    public function addThing(_arg_1:SmallObject):void
    {
        if ((!(_arg_1.onProcess)))
        {
            this._objectList.push(_arg_1);
            _arg_1.onProcess = true;
            this.startup();
        };
    }

    public function removeThing(_arg_1:SmallObject):void
    {
        if ((!(_arg_1.onProcess)))
        {
            return;
        };
        var _local_2:int = this._objectList.length;
        var _local_3:int;
        while (_local_3 < _local_2)
        {
            if (this._objectList[_local_3] == _arg_1)
            {
                this._objectList.splice(_local_3, 1);
                _arg_1.onProcess = false;
                if (this._objectList.length <= 0)
                {
                    this.shutdown();
                };
                return;
            };
            _local_3++;
        };
    }

    public function startup():void
    {
        if ((!(this._startuped)))
        {
            this._lastTime = getTimer();
            StageReferance.stage.addEventListener(Event.ENTER_FRAME, this.__onFrame);
            this._startuped = true;
        };
    }

    /*private*/ function __onFrame(_arg_1:Event):void
    {
        var _local_5:SmallObject;
        var _local_2:int = getTimer();
        var _local_3:int = (_local_2 - this._lastTime);
        var _local_4:int = getTimer();
        for each (_local_5 in this._objectList)
        {
            _local_5.onFrame(_local_3);
        };
        this._lastTime = _local_2;
    }

    public function shutdown():void
    {
        if (this._startuped)
        {
            this._lastTime = 0;
            StageReferance.stage.removeEventListener(Event.ENTER_FRAME, this.__onFrame);
            this._startuped = false;
        };
    }

    public function dispose():void
    {
        this.shutdown();
        var _local_1:SmallObject = this._objectList.shift();
        while (_local_1 != null)
        {
            _local_1.onProcess = false;
            _local_1 = this._objectList.shift();
        };
        this._objectList = null;
    }


}


