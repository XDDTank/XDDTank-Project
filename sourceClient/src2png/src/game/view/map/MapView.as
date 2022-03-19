// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.map.MapView

package game.view.map
{
    import phy.maps.Map;
    import game.model.GameInfo;
    import ddt.data.map.MapInfo;
    import game.animations.AnimationSet;
    import game.view.smallMap.SmallMapView;
    import game.actions.ActionManager;
    import game.view.GameViewBase;
    import game.objects.GameLiving;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import game.model.TurnedLiving;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import game.objects.GamePlayer;
    import flash.display.Sprite;
    import game.GameManager;
    import flash.display.Bitmap;
    import phy.maps.Ground;
    import ddt.data.PathInfo;
    import game.animations.AnimationLevel;
    import flash.events.MouseEvent;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatEvent;
    import ddt.loader.MapLoader;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import game.animations.SpellSkillAnimation;
    import game.animations.IAnimate;
    import game.model.Player;
    import game.animations.MultiSpellSkillAnimation;
    import flash.geom.Transform;
    import flash.geom.Matrix;
    import game.animations.BaseSetCenterAnimation;
    import game.animations.ShockingSetCenterAnimation;
    import game.model.Living;
    import game.actions.BaseAction;
    import im.IMController;
    import flash.system.IME;
    import ddt.manager.IMEManager;
    import flash.text.TextField;
    import com.pickgliss.toplevel.StageReferance;
    import flash.text.TextFieldType;
    import ddt.manager.SharedManager;
    import flash.utils.getTimer;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import phy.object.PhysicalObj;
    import phy.object.Physics;
    import ddt.view.FaceContainer;
    import game.animations.NewHandAnimation;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class MapView extends Map 
    {

        public static const ADD_BOX:String = "addBox";
        public static const FRAMERATE_OVER_COUNT:int = 25;
        public static const OVER_FRAME_GAPE:int = 46;

        private var _game:GameInfo;
        private var _info:MapInfo;
        private var _animateSet:AnimationSet;
        private var _minX:Number;
        private var _minY:Number;
        private var _minScaleX:Number;
        private var _minScaleY:Number;
        private var _minSkyScaleX:Number;
        private var _minScale:Number;
        private var _smallMap:SmallMapView;
        private var _actionManager:ActionManager;
        public var gameView:GameViewBase;
        public var currentFocusedLiving:GameLiving;
        private var _circle:Shape;
        private var _y:Number;
        private var _x:Number;
        private var _screenRect:Rectangle;
        public var isMultiShootMap:Boolean;
        private var _lockPositon:Boolean;
        private var _currentFocusedLiving:GameLiving;
        private var _currentFocusLevel:int;
        private var _currentPlayer:TurnedLiving;
        private var _smallObjs:Array;
        private var _scale:Number = 1;
        private var _frameRateCounter:int;
        private var _currentFrameRateOverCount:int = 0;
        private var _frameRateAlert:BaseAlerFrame;
        private var _objects:Dictionary = new Dictionary();
        public var _gamePlayerList:Vector.<GamePlayer> = new Vector.<GamePlayer>();
        private var expName:Vector.<String> = new Vector.<String>();
        private var expDic:Dictionary = new Dictionary();
        private var _currentTopLiving:GameLiving;
        private var _container:Sprite;

        public function MapView(_arg_1:GameInfo, _arg_2:MapLoader)
        {
            GameManager.Instance.Current.selfGamePlayer.currentMap = this;
            this._game = _arg_1;
            var _local_3:Bitmap = new Bitmap(_arg_2.backBmp.bitmapData);
            var _local_4:Ground = ((_arg_2.foreBmp) ? new Ground(_arg_2.foreBmp.bitmapData.clone(), true) : null);
            var _local_5:Ground = ((_arg_2.deadBmp) ? new Ground(_arg_2.deadBmp.bitmapData.clone(), false) : null);
            var _local_6:MapInfo = _arg_2.info;
            _local_3.cacheAsBitmap = true;
            super(_local_3, _local_4, _local_5, _arg_2.middle);
            airResistance = _local_6.DragIndex;
            gravity = _local_6.Weight;
            this._info = _local_6;
            this._animateSet = new AnimationSet(this, PathInfo.GAME_WIDTH, PathInfo.GAME_HEIGHT);
            this._smallMap = new SmallMapView(this, GameManager.Instance.Current.missionInfo);
            this._smallMap.update();
            this._smallObjs = new Array();
            this._minX = (-(bound.width) + PathInfo.GAME_WIDTH);
            this._minY = (-(bound.height) + PathInfo.GAME_HEIGHT);
            this._minScaleX = (PathInfo.GAME_WIDTH / bound.width);
            this._minScaleY = (PathInfo.GAME_HEIGHT / bound.height);
            this._minSkyScaleX = (PathInfo.GAME_WIDTH / _sky.width);
            if (this._minScaleX < this._minScaleY)
            {
                this._minScale = this._minScaleY;
            }
            else
            {
                this._minScale = this._minScaleX;
            };
            if (this._minScaleX < this._minSkyScaleX)
            {
                this._minScale = this._minSkyScaleX;
            }
            else
            {
                this._minScale = this._minScaleX;
            };
            this._actionManager = new ActionManager();
            this.setCenter((this._info.ForegroundWidth / 2), (this._info.ForegroundHeight / 2), false, AnimationLevel.MIDDLE, AnimationSet.PUBLIC_OWNER);
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            ChatManager.Instance.addEventListener(ChatEvent.SET_FACECONTIANER_LOCTION, this.__setFacecontainLoctionAction);
        }

        public function get lockPositon():Boolean
        {
            return (this._lockPositon);
        }

        public function set lockPositon(_arg_1:Boolean):void
        {
            this._lockPositon = _arg_1;
        }

        public function requestForFocus(_arg_1:GameLiving, _arg_2:int=0):void
        {
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            var _local_3:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
            var _local_4:int = GameManager.Instance.Current.selfGamePlayer.pos.y;
            if (this._currentFocusedLiving)
            {
                if (Math.abs((_arg_1.pos.x - _local_3)) > Math.abs((this._currentFocusedLiving.x - _local_3)))
                {
                    return;
                };
            };
            if (_arg_2 < this._currentFocusLevel)
            {
                return;
            };
            this._currentFocusedLiving = _arg_1;
            this._currentFocusLevel = _arg_2;
            this._currentFocusedLiving.needFocus(0, 0, {
                "strategy":"directly",
                "priority":_arg_2
            });
        }

        public function cancelFocus(_arg_1:GameLiving=null):void
        {
            if (_arg_1 == null)
            {
                this._currentFocusedLiving = null;
                this._currentFocusLevel = 0;
            };
            if (_arg_1 == this._currentFocusedLiving)
            {
                this._currentFocusedLiving = null;
                this._currentFocusLevel = 0;
            };
        }

        public function get currentPlayer():TurnedLiving
        {
            return (this._currentPlayer);
        }

        public function set currentPlayer(_arg_1:TurnedLiving):void
        {
            this._currentPlayer = _arg_1;
        }

        public function get game():GameInfo
        {
            return (this._game);
        }

        public function get info():MapInfo
        {
            return (this._info);
        }

        public function get smallMap():SmallMapView
        {
            return (this._smallMap);
        }

        public function get animateSet():AnimationSet
        {
            return (this._animateSet);
        }

        private function __setFacecontainLoctionAction(_arg_1:Event):void
        {
            this.setExpressionLoction();
        }

        private function get minX():Number
        {
            return ((-(bound.width) * this.scale) + PathInfo.GAME_WIDTH);
        }

        private function get minY():Number
        {
            return ((-(bound.height) * this.scale) + PathInfo.GAME_HEIGHT);
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            stage.focus = this;
            if (ChatManager.Instance.input.parent)
            {
                SoundManager.instance.play("008");
                ChatManager.Instance.switchVisible();
            };
        }

        public function spellKill(_arg_1:GamePlayer):IAnimate
        {
            var _local_2:SpellSkillAnimation = new SpellSkillAnimation(_arg_1.x, _arg_1.y, PathInfo.GAME_WIDTH, PathInfo.GAME_HEIGHT, this._info.ForegroundWidth, this._info.ForegroundHeight, _arg_1, this.gameView);
            this.animateSet.addAnimation(_local_2);
            SoundManager.instance.play("097");
            return (_local_2);
        }

        public function playMultiSpellkill(_arg_1:Vector.<GamePlayer>):IAnimate
        {
            var _local_2:Player = (this._game.findLiving(this._animateSet.lockOwnerID) as Player);
            if ((!(_local_2)))
            {
                _local_2 = _arg_1[0].player;
            };
            var _local_3:MultiSpellSkillAnimation = new MultiSpellSkillAnimation(_local_2.pos.x, _local_2.pos.y, PathInfo.GAME_WIDTH, PathInfo.GAME_HEIGHT, this._info.ForegroundWidth, this._info.ForegroundHeight, _arg_1, this.gameView);
            this.animateSet.addAnimation(_local_3);
            SoundManager.instance.play("097");
            return (_local_3);
        }

        public function get isPlayingMovie():Boolean
        {
            return ((this._animateSet.current is SpellSkillAnimation) || (this._animateSet.current is MultiSpellSkillAnimation));
        }

        override public function set x(_arg_1:Number):void
        {
            _arg_1 = ((_arg_1 < this.minX) ? this.minX : ((_arg_1 > 0) ? 0 : _arg_1));
            this._x = _arg_1;
            super.x = this._x;
        }

        override public function set y(_arg_1:Number):void
        {
            _arg_1 = ((_arg_1 < this.minY) ? this.minY : ((_arg_1 > 0) ? 0 : _arg_1));
            this._y = _arg_1;
            super.y = this._y;
        }

        override public function get x():Number
        {
            return (this._x);
        }

        override public function get y():Number
        {
            return (this._y);
        }

        override public function set transform(_arg_1:Transform):void
        {
            super.transform = _arg_1;
        }

        public function set scale(_arg_1:Number):void
        {
            if (_arg_1 > 1)
            {
                _arg_1 = 1;
            };
            if (_arg_1 < this._minScale)
            {
                _arg_1 = this._minScale;
            };
            this._scale = _arg_1;
            var _local_2:Matrix = new Matrix();
            _local_2.scale(this._scale, this._scale);
            transform.matrix = _local_2;
            _sky.scaleX = (_sky.scaleY = Math.pow(this._scale, (-1 / 2)));
            this.updateSky();
        }

        public function get minScale():Number
        {
            return (this._minScale);
        }

        public function get scale():Number
        {
            return (this._scale);
        }

        public function setCenter(_arg_1:Number, _arg_2:Number, _arg_3:Boolean, _arg_4:int=1, _arg_5:int=-1):void
        {
            this._animateSet.addAnimation(new BaseSetCenterAnimation(_arg_1, _arg_2, 50, (!(_arg_3)), AnimationLevel.MIDDLE, _arg_5));
        }

        public function scenarioSetCenter(_arg_1:Number, _arg_2:Number, _arg_3:int):void
        {
            switch (_arg_3)
            {
                case 3:
                    this._animateSet.addAnimation(new ShockingSetCenterAnimation(_arg_1, _arg_2, 50, false, AnimationLevel.HIGHT, 9, AnimationSet.PUBLIC_OWNER));
                    return;
                case 2:
                    this._animateSet.addAnimation(new ShockingSetCenterAnimation(_arg_1, _arg_2, 165, false, AnimationLevel.HIGHT, 9, AnimationSet.PUBLIC_OWNER));
                    return;
                default:
                    this._animateSet.addAnimation(new BaseSetCenterAnimation(_arg_1, _arg_2, 100, false, AnimationLevel.HIGHT, AnimationSet.PUBLIC_OWNER, 4));
            };
        }

        public function addAnimation(_arg_1:IAnimate, _arg_2:*):void
        {
            this._animateSet.addAnimation(_arg_1);
        }

        public function livingSetCenter(_arg_1:Number, _arg_2:Number, _arg_3:Boolean, _arg_4:int=2, _arg_5:int=0, _arg_6:Object=null):void
        {
            if ((_arg_6 is Living))
            {
                _arg_6 = null;
            };
            if (this._animateSet)
            {
                this._animateSet.addAnimation(new BaseSetCenterAnimation(_arg_1, _arg_2, 25, (!(_arg_3)), _arg_4, _arg_5, 0, _arg_6));
            };
        }

        public function setSelfCenter(_arg_1:Boolean, _arg_2:int=2, _arg_3:Object=null):void
        {
            var _local_4:Living = this._game.livings[this._game.selfGamePlayer.LivingID];
            if (_local_4 == null)
            {
                return;
            };
            this._animateSet.addAnimation(new BaseSetCenterAnimation((_local_4.pos.x - 50), (_local_4.pos.y - 150), 25, (!(_arg_1)), _arg_2, _local_4.LivingID, 0, _arg_3));
        }

        public function act(_arg_1:BaseAction):void
        {
            this._actionManager.act(_arg_1);
        }

        public function showShoot(_arg_1:Number, _arg_2:Number):void
        {
            this._circle = new Shape();
            this._circle.graphics.beginFill(0xFF0000);
            this._circle.graphics.drawCircle(_arg_1, _arg_2, 3);
            this._circle.graphics.drawCircle(_arg_1, _arg_2, 1);
            this._circle.graphics.endFill();
            addChild(this._circle);
        }

        override protected function update(_arg_1:Boolean=true):void
        {
            super.update(_arg_1);
            if ((!(IMController.Instance.privateChatFocus)))
            {
                if (ChatManager.Instance.input.parent == null)
                {
                    if (IME.enabled)
                    {
                        IMEManager.disable();
                    };
                    if (((stage) && (stage.focus == null)))
                    {
                        stage.focus = this;
                    };
                };
                if (((StageReferance.stage.focus is TextField) && (TextField(StageReferance.stage.focus).type == TextFieldType.INPUT)))
                {
                    if ((!(IME.enabled)))
                    {
                        IMEManager.enable();
                    };
                }
                else
                {
                    if (IME.enabled)
                    {
                        IMEManager.disable();
                    };
                };
            }
            else
            {
                if ((!(IME.enabled)))
                {
                    IMEManager.enable();
                };
            };
            this._actionManager.execute();
            if (this._animateSet.update())
            {
                this.updateSky();
            };
            this.checkOverFrameRate();
            if ((!(this._lockPositon)))
            {
                this.x = this.x;
                this.y = this.y;
            };
        }

        private function checkOverFrameRate():void
        {
            if (SharedManager.Instance.hasCheckedOverFrameRate)
            {
                return;
            };
            if (this._game == null)
            {
                return;
            };
            if (this._game.PlayerCount <= 4)
            {
                return;
            };
            if (((this._currentPlayer) && (this._currentPlayer.LivingID == this._game.selfGamePlayer.LivingID)))
            {
                return;
            };
            var _local_1:int = getTimer();
            if ((((_local_1 - this._frameRateCounter) > OVER_FRAME_GAPE) && (!(this._frameRateCounter == 0))))
            {
                this._currentFrameRateOverCount++;
                if (this._currentFrameRateOverCount > FRAMERATE_OVER_COUNT)
                {
                    if (((this._frameRateAlert == null) && (SharedManager.Instance.showParticle)))
                    {
                        this._frameRateAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("tank.game.map.smallMapView.slow"), "", LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                        this._frameRateAlert.addEventListener(FrameEvent.RESPONSE, this.__onRespose);
                        SharedManager.Instance.hasCheckedOverFrameRate = true;
                        SharedManager.Instance.save();
                    };
                };
            }
            else
            {
                this._currentFrameRateOverCount = 0;
            };
            this._frameRateCounter = _local_1;
        }

        private function __onRespose(_arg_1:FrameEvent):void
        {
            this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE, this.__onRespose);
            this._frameRateAlert.dispose();
            SharedManager.Instance.showParticle = false;
        }

        private function overFrameOk():void
        {
            SharedManager.Instance.showParticle = false;
        }

        public function get mapBitmap():Bitmap
        {
            var _local_1:BitmapData = new BitmapData(StageReferance.stageWidth, StageReferance.stageHeight);
            var _local_2:Point = globalToLocal(new Point(0, 0));
            _local_1.draw(this, new Matrix(1, 0, 0, 1, -(_local_2.x), -(_local_2.y)), null, null);
            return (new Bitmap(_local_1, "auto", true));
        }

        private function updateSky():void
        {
            if (this._scale < 1)
            {
            };
            var _local_1:Number = ((_sky.width - PathInfo.GAME_WIDTH) / (bound.width - PathInfo.GAME_WIDTH));
            var _local_2:Number = ((_sky.height - PathInfo.GAME_HEIGHT) / (bound.height - PathInfo.GAME_HEIGHT));
            if ((!(isNaN(_local_1))))
            {
                _sky.x = (-(this.x) + (this.x * _local_1));
            };
            if ((!(isNaN(_local_2))))
            {
                _sky.y = ((-(this.y) / scaleY) + ((this.y * _local_2) / scaleY));
            };
            this._smallMap.setScreenPos(this.x, this.y);
        }

        public function getPhysical(_arg_1:int):PhysicalObj
        {
            return (this._objects[_arg_1]);
        }

        public function getPhysicalAll():Dictionary
        {
            return (this._objects);
        }

        override public function addPhysical(_arg_1:Physics):void
        {
            var _local_2:PhysicalObj;
            super.addPhysical(_arg_1);
            if ((_arg_1 is PhysicalObj))
            {
                _local_2 = (_arg_1 as PhysicalObj);
                this._objects[_local_2.Id] = _local_2;
                if (_local_2.smallView)
                {
                    this._smallMap.addObj(_local_2.smallView);
                    this._smallMap.updatePos(_local_2.smallView, _local_2.pos);
                };
            };
            if ((_arg_1 is GamePlayer))
            {
                this._gamePlayerList.push(_arg_1);
            };
        }

        private function controlExpNum(_arg_1:GamePlayer):void
        {
            var _local_2:int;
            var _local_3:String;
            var _local_4:FaceContainer;
            if (this.expName.length < 2)
            {
                if (this.expName.indexOf(_arg_1.facecontainer.nickName.text) < 0)
                {
                    this.expName.push(_arg_1.facecontainer.nickName.text);
                    this.expDic[_arg_1.facecontainer.nickName.text] = _arg_1.facecontainer;
                };
            }
            else
            {
                if (this.expName.indexOf(_arg_1.facecontainer.nickName.text) < 0)
                {
                    _local_2 = int((Math.random() * 2));
                    _local_3 = this.expName[_local_2];
                    _local_4 = (this.expDic[_local_3] as FaceContainer);
                    if (_local_4.isActingExpression)
                    {
                        _local_4.doClearFace();
                    };
                    this.expName[_local_2] = _arg_1.facecontainer.nickName.text;
                    delete this.expDic[_local_3];
                    this.expDic[_arg_1.facecontainer.nickName.text] = _arg_1.facecontainer;
                };
            };
        }

        private function resetDicAndVec(_arg_1:GamePlayer):void
        {
            var _local_2:int = this.expName.indexOf(_arg_1.facecontainer.nickName.text);
            if (_local_2 >= 0)
            {
                delete this.expDic[this.expName[_local_2]];
                this.expName.splice(_local_2, 1);
            };
        }

        public function setExpressionLoction():void
        {
            var _local_2:GamePlayer;
            var _local_3:Point;
            var _local_4:int;
            if (this._gamePlayerList.length == 0)
            {
                return;
            };
            var _local_1:int;
            for (;_local_1 < this._gamePlayerList.length;_local_1++)
            {
                _local_2 = this._gamePlayerList[_local_1];
                if ((((_local_2 == null) || (!(_local_2.isLiving))) || (_local_2.facecontainer == null)))
                {
                    this._gamePlayerList.splice(_local_1, 1);
                }
                else
                {
                    if (_local_2.facecontainer.isActingExpression)
                    {
                        if (((_local_2.facecontainer.expressionID >= 49) || (_local_2.facecontainer.expressionID <= 0))) continue;
                        _local_3 = this.localToGlobal(new Point(_local_2.x, _local_2.y));
                        _local_4 = this.onStageFlg(_local_3);
                        if (_local_4 == 0)
                        {
                            _local_2.facecontainer.x = 0;
                            _local_2.facecontainer.y = -100;
                            this.resetDicAndVec(_local_2);
                            _local_2.facecontainer.isShowNickName = false;
                        }
                        else
                        {
                            if (_local_4 == 1)
                            {
                                _local_2.facecontainer.x = (((_local_2.facecontainer.width / 2) + 30) - _local_3.x);
                                _local_2.facecontainer.y = ((270 + (_local_2.facecontainer.height / 2)) - _local_3.y);
                                this.controlExpNum(_local_2);
                                _local_2.facecontainer.isShowNickName = true;
                            };
                        };
                        if (this.expName.length == 2)
                        {
                            (this.expDic[this.expName[1]] as FaceContainer).x = ((this.expDic[this.expName[1]] as FaceContainer).x + 80);
                        };
                    }
                    else
                    {
                        _local_2.facecontainer.x = 0;
                        _local_2.facecontainer.y = -100;
                        _local_2.facecontainer.isShowNickName = false;
                        this.resetDicAndVec(_local_2);
                    };
                };
            };
        }

        private function onStageFlg(_arg_1:Point):int
        {
            if (_arg_1 == null)
            {
                return (100);
            };
            if (((((_arg_1.x >= 0) && (_arg_1.x <= 1000)) && (_arg_1.y >= 0)) && (_arg_1.y <= 600)))
            {
                return (0);
            };
            return (1);
        }

        public function addObject(_arg_1:Physics):void
        {
            var _local_2:PhysicalObj;
            if ((_arg_1 is PhysicalObj))
            {
                _local_2 = (_arg_1 as PhysicalObj);
                this._objects[_local_2.Id] = _local_2;
            };
        }

        public function bringToFront(_arg_1:Living):void
        {
            var _local_3:GamePlayer;
            var _local_4:int;
            var _local_5:int;
            if ((!(_arg_1)))
            {
                return;
            };
            var _local_2:Physics = (this._objects[_arg_1.LivingID] as Physics);
            if (_local_2)
            {
                super.addPhysical(_local_2);
                if ((_local_2 is GamePlayer))
                {
                    _local_3 = (_local_2 as GamePlayer);
                    if (((((_local_3) && (_livingLayer.contains(_local_3))) && (_local_3.gamePet)) && (_livingLayer.contains(_local_3.gamePet))))
                    {
                        _local_4 = _livingLayer.getChildIndex(_local_3.gamePet);
                        _local_5 = _livingLayer.getChildIndex(_local_3);
                        if (_local_3.gamePet.isDefence)
                        {
                            _livingLayer.addChildAt(_local_3.gamePet, Math.max(_local_4, _local_5));
                        }
                        else
                        {
                            _livingLayer.addChildAt(_local_3.gamePet, Math.min(_local_4, _local_5));
                        };
                    };
                };
            };
        }

        public function phyBringToFront(_arg_1:PhysicalObj):void
        {
            if (_arg_1)
            {
                super.addChild(_arg_1);
            };
        }

        override public function removePhysical(_arg_1:Physics):void
        {
            var _local_2:PhysicalObj;
            super.removePhysical(_arg_1);
            if ((_arg_1 is PhysicalObj))
            {
                _local_2 = (_arg_1 as PhysicalObj);
                if (((this._objects) && (this._objects[_local_2.Id])))
                {
                    delete this._objects[_local_2.Id];
                };
                if (((this._smallMap) && (_local_2.smallView)))
                {
                    this._smallMap.removeObj(_local_2.smallView);
                };
            };
        }

        override public function addMapThing(_arg_1:Physics):void
        {
            var _local_2:PhysicalObj;
            super.addMapThing(_arg_1);
            if ((_arg_1 is PhysicalObj))
            {
                _local_2 = (_arg_1 as PhysicalObj);
                this._objects[_local_2.Id] = _local_2;
                if (_local_2.smallView)
                {
                    this._smallMap.addObj(_local_2.smallView);
                    this._smallMap.updatePos(_local_2.smallView, _local_2.pos);
                };
            };
        }

        override public function removeMapThing(_arg_1:Physics):void
        {
            var _local_2:PhysicalObj;
            super.removeMapThing(_arg_1);
            if ((_arg_1 is PhysicalObj))
            {
                _local_2 = (_arg_1 as PhysicalObj);
                if (this._objects[_local_2.Id])
                {
                    delete this._objects[_local_2.Id];
                };
                if (_local_2.smallView)
                {
                    this._smallMap.removeObj(_local_2.smallView);
                };
            };
        }

        public function get actionCount():int
        {
            return (this._actionManager.actionCount);
        }

        public function lockFocusAt(_arg_1:Point):void
        {
            this.animateSet.addAnimation(new NewHandAnimation(_arg_1.x, (_arg_1.y - 150), int.MAX_VALUE, false, AnimationLevel.HIGHEST));
        }

        public function releaseFocus():void
        {
            this.animateSet.clear();
        }

        public function executeAtOnce():void
        {
            this._actionManager.executeAtOnce();
            this._animateSet.clear();
        }

        public function bringToStageTop(_arg_1:PhysicalObj):void
        {
            if (this._currentTopLiving)
            {
                this.addPhysical(this._currentTopLiving);
            };
            if (((this._container) && (this._container.parent)))
            {
                this._container.parent.removeChild(this._container);
            };
            this._currentTopLiving = (this._objects[_arg_1.Id] as GameLiving);
            if (this._container == null)
            {
                this._container = new Sprite();
                this._container.x = this.x;
                this._container.y = this.y;
            };
            if (this._currentTopLiving)
            {
                this._container.addChild(this._currentTopLiving);
            };
            LayerManager.Instance.addToLayer(this._container, LayerManager.GAME_BASE_LAYER, false, 0, false);
        }

        public function restoreStageTopLiving():void
        {
            if (((this._currentTopLiving) && (this._currentTopLiving.isExist)))
            {
                this.addPhysical(this._currentTopLiving);
            };
            if (((this._container) && (this._container.parent)))
            {
                this._container.parent.removeChild(this._container);
            };
            this._currentTopLiving = null;
        }

        public function setMatrx(_arg_1:Matrix):void
        {
            transform.matrix = _arg_1;
            if (this._container)
            {
                this._container.transform.matrix = _arg_1;
            };
        }

        public function getContains(_arg_1:Number, _arg_2:Number, _arg_3:Number=1000, _arg_4:Number=600):Boolean
        {
            var _local_5:Number = (-(this._x) + ((PathInfo.GAME_WIDTH - _arg_3) / 2));
            var _local_6:Number = (-(this._y) + ((PathInfo.GAME_HEIGHT - _arg_4) / 2));
            this._screenRect = new Rectangle(_local_5, _local_6, _arg_3, _arg_4);
            return (this._screenRect.contains(_arg_1, _arg_2));
        }

        public function getMarginal(_arg_1:Number, _arg_2:Number, _arg_3:Number=1000, _arg_4:Number=600, _arg_5:Number=0, _arg_6:Number=0):Boolean
        {
            var _local_7:Number = (-(this._x) + _arg_5);
            var _local_8:Number = (-(this._y) + _arg_6);
            var _local_9:Rectangle = new Rectangle(_local_7, _local_8, _arg_3, _arg_4);
            return (_local_9.contains(_arg_1, _arg_2));
        }

        public function hasScreen(_arg_1:Number=1000, _arg_2:Number=600):Boolean
        {
            var _local_3:Number = GameManager.Instance.Current.selfGamePlayer.pos.x;
            var _local_4:Number = GameManager.Instance.Current.selfGamePlayer.pos.y;
            var _local_5:Living = GameManager.Instance.getMinDistanceLiving(GameManager.Instance.Current.selfGamePlayer);
            if ((!(_local_5)))
            {
                return (false);
            };
            return ((this.getContains(_local_3, _local_4, _arg_1, _arg_2)) && (this.getContains(_local_5.pos.x, _local_5.pos.y, _arg_1, _arg_2)));
        }

        public function hasScreenCentre(_arg_1:Number=1000, _arg_2:Number=600, _arg_3:Number=0, _arg_4:Number=0):Boolean
        {
            var _local_5:Number = GameManager.Instance.Current.selfGamePlayer.pos.x;
            var _local_6:Number = GameManager.Instance.Current.selfGamePlayer.pos.y;
            var _local_7:Living = GameManager.Instance.getMinDistanceLiving(GameManager.Instance.Current.selfGamePlayer);
            if ((!(_local_7)))
            {
                return (false);
            };
            return ((this.getMarginal(_local_5, _local_6, _arg_1, _arg_2, _arg_3, _arg_4)) && (this.getMarginal(_local_7.pos.x, _local_7.pos.y, _arg_1, _arg_2, _arg_3, _arg_4)));
        }

        public function set lockOwner(_arg_1:int):void
        {
            this._animateSet.lockOwnerID = _arg_1;
        }

        public function get lockOwner():int
        {
            return (this._animateSet.lockOwnerID);
        }

        override public function dispose():void
        {
            var _local_1:PhysicalObj;
            super.dispose();
            this._currentTopLiving = null;
            ChatManager.Instance.removeEventListener(ChatEvent.SET_FACECONTIANER_LOCTION, this.__setFacecontainLoctionAction);
            ObjectUtils.disposeObject(this._container);
            this._container = null;
            if (this._frameRateAlert != null)
            {
                this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE, this.__onRespose);
                this._frameRateAlert.dispose();
                this._frameRateAlert = null;
            };
            for each (_local_1 in this._objects)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            this._objects = null;
            this._game = null;
            this._info = null;
            this._currentFocusedLiving = null;
            this.currentFocusedLiving = null;
            this._currentPlayer = null;
            this._smallMap.dispose();
            this._smallMap = null;
            this._animateSet.dispose();
            this._animateSet = null;
            this._actionManager.clear();
            this._actionManager = null;
            this.gameView = null;
            this._gamePlayerList = null;
        }


    }
}//package game.view.map

