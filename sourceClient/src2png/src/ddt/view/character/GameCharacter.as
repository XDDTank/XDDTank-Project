// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.GameCharacter

package ddt.view.character
{
    import ddt.command.PlayerAction;
    import flash.filters.ColorMatrixFilter;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import game.model.Player;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.ColorTransform;
    import com.pickgliss.ui.ComponentFactory;
    import road7th.utils.StringHelper;
    import ddt.utils.BitmapUtils;
    import flash.display.BlendMode;
    import flash.events.MouseEvent;
    import flash.utils.setTimeout;
    import com.pickgliss.utils.ClassUtils;
    import com.greensock.TweenMax;
    import com.greensock.events.TweenEvent;
    import flash.filters.GlowFilter;
    import flash.utils.getQualifiedClassName;
    import flash.geom.Matrix;
    import __AS3__.vec.*;

    public class GameCharacter extends BaseCharacter 
    {

        private static const STAND_FRAME_1:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 7, 7, 8, 8, 9, 9, 9, 9, 8, 8, 7, 7, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10];
        private static const STAND_FRAME_2:Array = [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 7, 7, 8, 8, 9, 9, 9, 9, 8, 8, 7, 7, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7];
        public static const STAND:PlayerAction = new PlayerAction("stand", [STAND_FRAME_1, STAND_FRAME_2], false, true, false);
        private static const LACK_FACE_DOWN:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        private static const LACK_FACE_UP:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        private static const STAND_LACK_HP_FRAME:Array = [0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0];
        private static const STAND_LACK_HP_FRAME_1:Array = [0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2];
        public static const STAND_LACK_HP:PlayerAction = new PlayerAction("standLackHP", [STAND_LACK_HP_FRAME, STAND_LACK_HP_FRAME_1], false, false, false);
        public static const WALK_LACK_HP:PlayerAction = new PlayerAction("walkLackHP", [[1, 1, 2, 2, 3, 3, 4, 4, 5, 5]], false, true, false);
        public static const WALK:PlayerAction = new PlayerAction("walk", [[1, 1, 2, 2, 3, 3, 4, 4, 5, 5]], false, true, false);
        public static const SHOT:PlayerAction = new PlayerAction("shot", [[22, 23, 26, 27]], true, false, true);
        public static const STOPSHOT:PlayerAction = new PlayerAction("stopshot", [[23]], true, false, false);
        public static const SHOWGUN:PlayerAction = new PlayerAction("showgun", [[19, 20, 21, 21, 21]], true, false, true);
        public static const HIDEGUN:PlayerAction = new PlayerAction("hidegun", [[27]], true, false, false);
        public static const THROWS:PlayerAction = new PlayerAction("throws", [[31, 32, 33, 34, 35]], true, false, true);
        public static const STOPTHROWS:PlayerAction = new PlayerAction("stopthrows", [[34]], true, false, false);
        public static const SHOWTHROWS:PlayerAction = new PlayerAction("showthrows", [[28, 29, 30, 30, 30]], true, false, true);
        public static const HIDETHROWS:PlayerAction = new PlayerAction("hidethrows", [[35]], true, false, false);
        public static const SHAKE:PlayerAction = new PlayerAction("shake", [[6, 6, 7, 7, 8, 8, 9, 9, 8, 8, 7, 7, 6, 6]], false, false, false);
        public static const HANDCLIP:PlayerAction = new PlayerAction("handclip", [[13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13]], true, false, false);
        public static const HANDCLIP_LACK_HP:PlayerAction = new PlayerAction("handclip", [[13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13, 14, 14, 15, 15, 14, 14, 13, 13]], true, false, false);
        public static const SOUL:PlayerAction = new PlayerAction("soul", [[0]], false, true, false);
        public static const SOUL_MOVE:PlayerAction = new PlayerAction("soulMove", [[1]], false, true, false);
        public static const SOUL_SMILE:PlayerAction = new PlayerAction("soulSmile", [[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]], false, false, false);
        public static const SOUL_CRY:PlayerAction = new PlayerAction("soulCry", [[3]], false, true, false);
        public static const CRY:PlayerAction = new PlayerAction("cry", [[16, 16, 17, 17, 18, 18, 16, 16, 17, 17, 18, 18, 16, 16, 17, 17, 18, 18, 16, 16, 17, 17, 18, 18, 16, 16, 17, 17, 18, 18]], false, false, false);
        public static const HIT:PlayerAction = new PlayerAction("hit", [[12, 12, 24, 24, 24, 24, 24, 24, 24, 24, 25, 25, 38, 38, 38, 38, 11, 11, 11, 11]], false, false, false);
        public static const SPECIAL_EFFECT_FRAMES:Array = [0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2];
        private static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
        public static const PET_CALL:PlayerAction = new PlayerAction("petCall", [[28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35]], false, false, false);
        public static const GAME_WING_WAIT:int = 1;
        public static const GAME_WING_MOVE:int = 2;
        public static const GAME_WING_CRY:int = 3;
        public static const GAME_WING_CLIP:int = 4;
        public static const GAME_WING_SHOOT:int = 5;

        private var _currentAction:PlayerAction;
        private var _defaultAction:PlayerAction;
        private var _wing:MovieClip;
        private var _ghostMovie:MovieClip;
        private var _ghostShine:MovieClip;
        private var _frameStartPoint:Point = new Point(0, 0);
        private var _spBitmapData:Vector.<BitmapData>;
        private var _faceupBitmapData:BitmapData;
        private var _faceBitmapData:BitmapData;
        private var _lackHpFaceBitmapdata:Vector.<BitmapData>;
        private var _faceDownBitmapdata:BitmapData;
        private var _normalSuit:BitmapData;
        private var _lackHpSuit:BitmapData;
        private var _soulFace:BitmapData;
        private var _tempCryFace:BitmapData;
        private var _cryTypes:Array = [0, 16, 13, 10];
        private var _cryType:int;
        private var _specialType:int = 0;
        private var _state:int = Player.FULL_HP;
        private var _rect:Rectangle;
        private var _hasSuitSoul:Boolean = true;
        private var _cryFrace:Sprite;
        private var _cryBmps:Vector.<Bitmap>;
        private var _defaultBody:MovieClip;
        protected var _colors:Array;
        private var _isLackHp:Boolean;
        private var _hasChangeToLackHp:Boolean;
        private var _index:int = (90 * Math.random());
        private var _isPlaying:Boolean = false;
        private var black:Boolean;
        private var blackBm:Bitmap;
        private var blackEyes:MovieClip;
        private var _wingState:int = 0;
        private var closeEys:int;

        public function GameCharacter(_arg_1:PlayerInfo)
        {
            super(_arg_1, true);
            this._currentAction = (this._defaultAction = STAND);
            _body.x = (_body.x - 62);
            _body.y = (_body.y - 83);
        }

        public function getCloneBody():Bitmap
        {
            return (new Bitmap(_body.bitmapData.clone(), "auto", true));
        }

        override protected function __loadComplete(_arg_1:ICharacterLoader):void
        {
            super.__loadComplete(_arg_1);
            if (this._defaultBody)
            {
                ObjectUtils.disposeObject(this._defaultBody);
                this._defaultBody = null;
            };
        }

        protected function CreateCryFrace(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:ColorTransform;
            var _local_5:Bitmap;
            ObjectUtils.disposeObject(this._tempCryFace);
            this._tempCryFace = null;
            if (this._cryBmps)
            {
                _local_2 = 0;
                while (_local_2 < this._cryBmps.length)
                {
                    ObjectUtils.disposeObject(this._cryBmps[_local_2]);
                    this._cryBmps[_local_2] = null;
                    _local_2++;
                };
                this._cryBmps = null;
            };
            ObjectUtils.disposeAllChildren(this._cryFrace);
            this._cryFrace = null;
            this._colors = _arg_1.split("|");
            this._cryFrace = new Sprite();
            this._cryBmps = new Vector.<Bitmap>(3);
            this._cryBmps[0] = ComponentFactory.Instance.creatBitmap("asset.game.character.cryFaceAsset");
            this._cryFrace.addChild(this._cryBmps[0]);
            this._cryBmps[1] = ComponentFactory.Instance.creatBitmap("asset.game.character.cryChangeColorAsset");
            this._cryFrace.addChild(this._cryBmps[1]);
            this._cryBmps[1].visible = false;
            if (this._colors.length == this._cryBmps.length)
            {
                _local_3 = 0;
                while (_local_3 < this._colors.length)
                {
                    if (((((!(StringHelper.isNullOrEmpty(this._colors[_local_3]))) && (!(this._colors[_local_3].toString() == "undefined"))) && (!(this._colors[_local_3].toString() == "null"))) && (this._cryBmps[_local_3])))
                    {
                        this._cryBmps[_local_3].visible = true;
                        this._cryBmps[_local_3].transform.colorTransform = BitmapUtils.getColorTransfromByColor(this._colors[_local_3]);
                        _local_4 = BitmapUtils.getHightlightColorTransfrom(this._colors[_local_3]);
                        _local_5 = new Bitmap(this._cryBmps[_local_3].bitmapData, "auto", true);
                        if (_local_4)
                        {
                            _local_5.transform.colorTransform = _local_4;
                        };
                        _local_5.blendMode = BlendMode.HARDLIGHT;
                        this._cryFrace.addChild(_local_5);
                    }
                    else
                    {
                        if (this._cryBmps[_local_3])
                        {
                            this._cryBmps[_local_3].transform.colorTransform = new ColorTransform();
                        };
                    };
                    _local_3++;
                };
            };
            this._tempCryFace = new BitmapData(this._cryFrace.width, this._cryFrace.height, true, 0);
            this._tempCryFace.draw(this._cryFrace, null, null, BlendMode.NORMAL);
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            if (_arg_1.altKey)
            {
                this._currentAction = SOUL_SMILE;
            }
            else
            {
                if (_arg_1.ctrlKey)
                {
                    this._currentAction = SOUL_MOVE;
                }
                else
                {
                    this._currentAction = SOUL;
                };
            };
        }

        public function set isLackHp(_arg_1:Boolean):void
        {
            this._isLackHp = _arg_1;
        }

        public function get State():int
        {
            return (this._state);
        }

        public function set State(_arg_1:int):void
        {
            if (this._state == _arg_1)
            {
                return;
            };
            this._state = _arg_1;
        }

        override protected function initSizeAndPics():void
        {
            setCharacterSize(114, 95);
            setPicNum(3, 13);
            this._rect = new Rectangle(0, 0, _characterWidth, _characterHeight);
        }

        public function get weaponX():int
        {
            return ((-(_characterWidth) / 2) - 5);
        }

        public function get weaponY():int
        {
            return (-(_characterHeight) + 12);
        }

        override protected function initLoader():void
        {
            _loader = _factory.createLoader(_info, CharacterLoaderFactory.GAME);
        }

        override public function update():void
        {
            if (this._isPlaying)
            {
                if (this._index < this._currentAction.frames[0].length)
                {
                    if (this.isDead)
                    {
                        this.drawFrame(this._currentAction.frames[0][this._index++], 8, true);
                    }
                    else
                    {
                        if (_info.getShowSuits())
                        {
                            this.drawFrame(this._currentAction.frames[0][this._index++], 6, true);
                        }
                        else
                        {
                            if (this._currentAction == STAND_LACK_HP)
                            {
                                this.drawFrame(LACK_FACE_DOWN[this._index], 1, true);
                                this.drawFrame(this._currentAction.frames[(this.STATES_ENUM[this._specialType][0] % 2)][this._index], 2, false);
                                this.drawFrame(LACK_FACE_UP[this._index], 4, false);
                                this.drawFrame(SPECIAL_EFFECT_FRAMES[this._index++], 5, false);
                            }
                            else
                            {
                                if (this._currentAction == STAND)
                                {
                                    this.drawFrame(STAND.frames[0][this._index], 1, true);
                                    this.drawFrame(STAND.frames[0][this._index], 3, false);
                                    this.drawFrame(STAND.frames[1][this._index++], 4, false);
                                }
                                else
                                {
                                    this.drawFrame(this._currentAction.frames[0][this._index], 1, true);
                                    this.drawFrame(this._currentAction.frames[0][this._index], 3, false);
                                    this.drawFrame(this._currentAction.frames[0][this._index++], 4, false);
                                };
                            };
                        };
                    };
                }
                else
                {
                    if (this._currentAction.repeat)
                    {
                        this._index = 0;
                        if (((this._currentAction == STAND) && (this._isLackHp)))
                        {
                            if (Math.random() < 0.33)
                            {
                                this.doAction(STAND_LACK_HP);
                            };
                        };
                    }
                    else
                    {
                        if (this._currentAction.stopAtEnd)
                        {
                            this._isPlaying = false;
                        }
                        else
                        {
                            if (this.isDead)
                            {
                                this.doAction(SOUL);
                            }
                            else
                            {
                                if (this._currentAction == CRY)
                                {
                                    if (Math.random() < 0.33)
                                    {
                                        this.doAction(STAND_LACK_HP);
                                    }
                                    else
                                    {
                                        this.doAction(STAND);
                                    };
                                }
                                else
                                {
                                    if (((this._isLackHp) && (this._currentAction == STAND)))
                                    {
                                        if (Math.random() < 0.33)
                                        {
                                            this.doAction(STAND_LACK_HP);
                                        };
                                    }
                                    else
                                    {
                                        this.doAction(STAND);
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function get STATES_ENUM():Array
        {
            if (_info.Sex)
            {
                return (GameCharacterLoader.MALE_STATES);
            };
            return (GameCharacterLoader.FEMALE_STATES);
        }

        public function bombed():void
        {
            if ((!(info.getShowSuits())))
            {
                if (this.black)
                {
                    return;
                };
                this.black = true;
                this.blackBm.alpha = 1;
                addChild(this.blackBm);
                setTimeout(this.blackEyes.gotoAndPlay, 300, 1);
                addChild(this.blackEyes);
                if (contains(_body))
                {
                    removeChild(_body);
                };
                this.switchWingVisible(false);
                setTimeout(this.changeToNormal, 2000);
            };
        }

        override protected function init():void
        {
            _currentframe = -1;
            this.initSizeAndPics();
            createFrames();
            _body = new Bitmap(new BitmapData(_characterWidth, _characterHeight, true, 0), "auto", true);
            addChild(_body);
            this._defaultBody = (ClassUtils.CreatInstance("asset.game.bodyDefaultPlayer") as MovieClip);
            addChild(this._defaultBody);
            mouseChildren = (mouseEnabled = false);
            _loadCompleted = false;
        }

        private function drawBlack(_arg_1:BitmapData):void
        {
            var _local_2:Rectangle = new Rectangle(0, 0, _arg_1.width, _arg_1.height);
            var _local_3:Vector.<uint> = _arg_1.getVector(_local_2);
            var _local_4:uint = _local_3.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_3[_local_5] = (((((_local_3[_local_5] >> 24) << 24) | (0 << 16)) | (0 << 8)) | 0x00);
                _local_5++;
            };
            _arg_1.setVector(_local_2, _local_3);
        }

        public function changeToNormal():void
        {
            var _local_1:TweenMax = TweenMax.to(this.blackBm, 0.25, {"alpha":0});
            _local_1.addEventListener(TweenEvent.COMPLETE, this.setBlack);
            if (this.blackEyes.parent)
            {
                removeChild(this.blackEyes);
            };
            addChild(_body);
            if ((!(this.isDead)))
            {
                this.switchWingVisible(true);
            };
        }

        private function get isDead():Boolean
        {
            return ((((this._currentAction == SOUL) || (this._currentAction == SOUL_CRY)) || (this._currentAction == SOUL_MOVE)) || (this._currentAction == SOUL_SMILE));
        }

        private function setBlack(_arg_1:TweenEvent):void
        {
            TweenMax(_arg_1.target).removeEventListener(TweenEvent.COMPLETE, this.setBlack);
            if (((this.blackBm) && (this.blackBm.parent)))
            {
                removeChild(this.blackBm);
            };
            this.black = false;
        }

        private function clearBomded():void
        {
            this.black = false;
            if (((this.blackEyes) && (this.blackEyes.parent)))
            {
                removeChild(this.blackEyes);
            };
            if (((this.blackBm) && (this.blackBm.parent)))
            {
                removeChild(this.blackBm);
            };
            addChild(_body);
        }

        public function get standAction():PlayerAction
        {
            if (((this.State == Player.FULL_HP) || (_info.getShowSuits())))
            {
                return (STAND);
            };
            return (STAND_LACK_HP);
        }

        public function get walkAction():PlayerAction
        {
            if (((this.State == Player.FULL_HP) || (_info.getShowSuits())))
            {
                return (WALK);
            };
            return (WALK_LACK_HP);
        }

        public function get handClipAction():PlayerAction
        {
            if (((this.State == Player.FULL_HP) || (_info.getShowSuits())))
            {
                return (HANDCLIP);
            };
            return (HANDCLIP_LACK_HP);
        }

        public function randomCryType():void
        {
            this._cryType = int((Math.random() * 4));
            if (((!(_info.getShowSuits())) && (this._lackHpFaceBitmapdata)))
            {
                this._specialType = int((Math.random() * this._lackHpFaceBitmapdata.length));
            };
        }

        override public function doAction(_arg_1:*):void
        {
            var _local_2:String;
            if (this._currentAction.canReplace(_arg_1))
            {
                this._currentAction = _arg_1;
                this._index = 0;
            };
            if (((this._currentAction == STAND) || (this._currentAction == STAND_LACK_HP)))
            {
                if (((this._ghostMovie) && (this._ghostMovie.parent)))
                {
                    this._ghostMovie.parent.removeChild(this._ghostMovie);
                };
                filters = null;
                if (((this._ghostShine) && (this._ghostShine.parent)))
                {
                    this._ghostShine.parent.removeChild(this._ghostShine);
                };
            }
            else
            {
                if (this.isDead)
                {
                    this.switchWingVisible(false);
                    this.clearBomded();
                    if (this._ghostShine == null)
                    {
                        this._ghostShine = (ClassUtils.CreatInstance("asset.game.ghostShineAsset") as MovieClip);
                    };
                    this._ghostShine.x = -28;
                    this._ghostShine.y = -50;
                    if (_info.getShowSuits())
                    {
                        if (this._hasSuitSoul)
                        {
                            _local_2 = ((_info.Sex) ? "asset.game.ghostManMovieAsset1" : "asset.game.ghostGirlMovieAsset1");
                            if (this._ghostMovie == null)
                            {
                                this._ghostMovie = (ClassUtils.CreatInstance(_local_2) as MovieClip);
                            };
                            addChildAt(this._ghostMovie, 0);
                            this._ghostMovie.x = -26;
                            this._ghostMovie.y = -50;
                        }
                        else
                        {
                            if (this._ghostMovie == null)
                            {
                                this._ghostMovie = (ClassUtils.CreatInstance("asset.game.ghostMovieAsset") as MovieClip);
                            };
                            addChildAt(this._ghostMovie, 0);
                        };
                    }
                    else
                    {
                        _local_2 = ((_info.Sex) ? "asset.game.ghostManMovieAsset" : "asset.game.ghostGirlMovieAsset");
                        if (((this._ghostMovie) && (this._ghostMovie.parent)))
                        {
                            this._ghostMovie.parent.removeChild(this._ghostMovie);
                            this._ghostMovie = null;
                        };
                        this._ghostMovie = (ClassUtils.CreatInstance(_local_2) as MovieClip);
                        addChild(this._ghostMovie);
                        this._ghostMovie.x = -26;
                        this._ghostMovie.y = -50;
                    };
                    filters = [new GlowFilter(7564475, 1, 6, 6, 2)];
                    addChild(this._ghostShine);
                }
                else
                {
                    if (((this._ghostMovie) && (this._ghostMovie.parent)))
                    {
                        this._ghostMovie.parent.removeChild(this._ghostMovie);
                    };
                    filters = null;
                    if (((this._ghostShine) && (this._ghostShine.parent)))
                    {
                        this._ghostShine.parent.removeChild(this._ghostShine);
                    };
                };
            };
            if (((((this.leftWing) && (this.leftWing.totalFrames == 2)) && (this.rightWing)) && (this.rightWing.totalFrames == 2)))
            {
                if (((this._currentAction == STAND) || (this._currentAction == STAND_LACK_HP)))
                {
                    this.WingState = GAME_WING_WAIT;
                    if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                    {
                        this.leftWing["movie"].gotoAndStop(1);
                        this.rightWing["movie"].gotoAndStop(1);
                    };
                }
                else
                {
                    if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                    {
                        this.leftWing["movie"].play();
                        this.rightWing["movie"].play();
                    };
                };
            }
            else
            {
                if (((this._currentAction == STAND) || (this._currentAction == STAND_LACK_HP)))
                {
                    this.WingState = GAME_WING_WAIT;
                    if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                    {
                        this.leftWing["movie"].gotoAndStop(1);
                        this.rightWing["movie"].gotoAndStop(1);
                    };
                }
                else
                {
                    if (((this._currentAction == WALK) || (this._currentAction == WALK_LACK_HP)))
                    {
                        if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                        {
                            this.leftWing["movie"].play();
                            this.rightWing["movie"].play();
                        };
                    }
                    else
                    {
                        if (this._currentAction == CRY)
                        {
                            if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                            {
                                this.leftWing["movie"].play();
                                this.rightWing["movie"].play();
                            };
                        }
                        else
                        {
                            if (((this._currentAction == HANDCLIP) || (this._currentAction == HANDCLIP_LACK_HP)))
                            {
                                if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                                {
                                    this.leftWing["movie"].play();
                                    this.rightWing["movie"].play();
                                };
                            }
                            else
                            {
                                if (((this._currentAction == SHOWGUN) || (this._currentAction == SHOWTHROWS)))
                                {
                                    if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                                    {
                                        this.leftWing["movie"].play();
                                        this.rightWing["movie"].play();
                                    };
                                }
                                else
                                {
                                    if (((((this.leftWing) && (this.leftWing["movie"])) && (this.rightWing)) && (this.rightWing["movie"])))
                                    {
                                        this.leftWing["movie"].play();
                                        this.rightWing["movie"].play();
                                    };
                                };
                            };
                        };
                    };
                };
            };
            this._isPlaying = true;
        }

        override public function actionPlaying():Boolean
        {
            return (this._isPlaying);
        }

        override public function get currentAction():*
        {
            return (this._currentAction);
        }

        override public function setDefaultAction(_arg_1:*):void
        {
            if ((_arg_1 is PlayerAction))
            {
                this._currentAction = _arg_1;
            };
        }

        override protected function setContent():void
        {
            var _local_1:Array;
            var _local_2:BitmapData;
            var _local_3:BitmapData;
            if (_loader != null)
            {
                if ((!(this.isDead)))
                {
                    if (this._ghostMovie)
                    {
                        ObjectUtils.disposeObject(this._ghostMovie);
                    };
                    this._ghostMovie = null;
                };
                _local_1 = _loader.getContent();
                if (_info.getShowSuits())
                {
                    if (((this._normalSuit) && (!(this._normalSuit == _local_1[6]))))
                    {
                        this._normalSuit.dispose();
                    };
                    this._normalSuit = _local_1[6];
                    if (((this._lackHpSuit) && (!(this._lackHpSuit == _local_1[7]))))
                    {
                        this._lackHpSuit.dispose();
                    };
                    this._lackHpSuit = _local_1[7];
                    this._hasSuitSoul = this.checkHasSuitsSoul(this._lackHpSuit);
                }
                else
                {
                    if (((this._spBitmapData) && (!(this._spBitmapData == _local_1[1]))))
                    {
                        for each (_local_2 in this._spBitmapData)
                        {
                            _local_2.dispose();
                        };
                    };
                    this._spBitmapData = _local_1[1];
                    if (((this._faceupBitmapData) && (!(this._faceupBitmapData == _local_1[2]))))
                    {
                        this._faceupBitmapData.dispose();
                    };
                    this._faceupBitmapData = _local_1[2];
                    if (((this._faceBitmapData) && (!(this._faceBitmapData == _local_1[3]))))
                    {
                        this._faceBitmapData.dispose();
                    };
                    this._faceBitmapData = _local_1[3];
                    if (((this._lackHpFaceBitmapdata) && (!(this._lackHpFaceBitmapdata == _local_1[4]))))
                    {
                        for each (_local_3 in this._lackHpFaceBitmapdata)
                        {
                            _local_3.dispose();
                        };
                    };
                    this._lackHpFaceBitmapdata = _local_1[4];
                    if (((this._faceDownBitmapdata) && (!(this._faceDownBitmapdata == _local_1[5]))))
                    {
                        this._faceDownBitmapdata.dispose();
                    };
                    this._faceDownBitmapdata = _local_1[5];
                };
                if (getQualifiedClassName(this._wing) != getQualifiedClassName(_local_1[0]))
                {
                    this.removeWing();
                    this._wing = _local_1[0];
                    this.WingState = GAME_WING_WAIT;
                };
                this.drawBomd();
                this.drawSoul();
                this.CreateCryFrace(_info.Colors.split(",")[5]);
                this._isPlaying = true;
                this.update();
            };
        }

        private function checkHasSuitsSoul(_arg_1:BitmapData):Boolean
        {
            var _local_4:int;
            var _local_2:Point = new Point(((_characterWidth * 11) - (_characterWidth / 2)), ((_characterHeight * 3) - (_characterHeight / 2)));
            var _local_3:int = (_local_2.x - 5);
            while (_local_3 < (_local_2.x + 5))
            {
                _local_4 = (_local_2.y - 5);
                while (_local_4 < (_local_2.y + 5))
                {
                    if (_arg_1.getPixel(_local_3, _local_4) != 0)
                    {
                        return (true);
                    };
                    _local_4++;
                };
                _local_3++;
            };
            return (false);
        }

        private function removeWing():void
        {
            if (this._wing == null)
            {
                return;
            };
            if (((this.rightWing) && (this.rightWing.parent)))
            {
                this.rightWing.parent.removeChild(this.rightWing);
            };
            if (((this.leftWing) && (this.leftWing.parent)))
            {
                this.leftWing.parent.removeChild(this.leftWing);
            };
            this._wing = null;
        }

        public function switchWingVisible(_arg_1:Boolean):void
        {
            if (((this.leftWing) && (this.rightWing)))
            {
                this.rightWing.visible = (this.leftWing.visible = _arg_1);
            };
        }

        public function setWingPos(_arg_1:Number, _arg_2:Number):void
        {
            if (((this.rightWing) && (this.leftWing)))
            {
                this.rightWing.x = (this.leftWing.x = _arg_1);
                this.rightWing.y = (this.leftWing.y = _arg_2);
            };
        }

        public function setWingScale(_arg_1:Number, _arg_2:Number):void
        {
            if (((this.rightWing) && (this.leftWing)))
            {
                this.leftWing.scaleX = (this.rightWing.scaleX = _arg_1);
                this.leftWing.scaleY = (this.rightWing.scaleY = _arg_2);
            };
        }

        public function set WingState(_arg_1:int):void
        {
            this._wingState = _arg_1;
            if (((((this.leftWing) && (this.leftWing.totalFrames == 2)) && (this.rightWing)) && (this.rightWing.totalFrames == 2)))
            {
                if (this._wingState == GAME_WING_SHOOT)
                {
                    this._wingState = 2;
                }
                else
                {
                    this._wingState = 1;
                };
            };
            if (((this.leftWing) && (this.rightWing)))
            {
                this.leftWing.gotoAndStop(this._wingState);
                this.rightWing.gotoAndStop(this._wingState);
            };
        }

        public function get WingState():int
        {
            return (this._wingState);
        }

        public function get wing():MovieClip
        {
            return (this._wing);
        }

        public function get leftWing():MovieClip
        {
            if (this._wing)
            {
                return (this._wing["leftWing"]);
            };
            return (null);
        }

        public function get rightWing():MovieClip
        {
            if (this._wing)
            {
                return (this._wing["rightWing"]);
            };
            return (null);
        }

        override public function dispose():void
        {
            var _local_1:int;
            this.removeWing();
            ObjectUtils.disposeObject(this._ghostMovie);
            this._ghostMovie = null;
            ObjectUtils.disposeObject(this._ghostShine);
            this._ghostShine = null;
            while (((this._spBitmapData) && (this._spBitmapData.length > 0)))
            {
                this._spBitmapData.shift().dispose();
            };
            this._spBitmapData = null;
            ObjectUtils.disposeObject(this._faceupBitmapData);
            this._faceupBitmapData = null;
            ObjectUtils.disposeObject(this._faceBitmapData);
            this._faceBitmapData = null;
            while (((this._lackHpFaceBitmapdata) && (this._lackHpFaceBitmapdata.length > 0)))
            {
                this._lackHpFaceBitmapdata.shift().dispose();
            };
            this._spBitmapData = null;
            ObjectUtils.disposeObject(this._faceDownBitmapdata);
            this._faceDownBitmapdata = null;
            ObjectUtils.disposeObject(this._normalSuit);
            this._normalSuit = null;
            ObjectUtils.disposeObject(this._lackHpSuit);
            this._lackHpSuit = null;
            ObjectUtils.disposeObject(this._soulFace);
            this._soulFace = null;
            ObjectUtils.disposeObject(this._tempCryFace);
            this._tempCryFace = null;
            ObjectUtils.disposeObject(this._wing);
            this._wing = null;
            if (this._cryBmps)
            {
                _local_1 = 0;
                while (_local_1 < this._cryBmps.length)
                {
                    ObjectUtils.disposeObject(this._cryBmps[_local_1]);
                    this._cryBmps[_local_1] = null;
                    _local_1++;
                };
            };
            ObjectUtils.disposeAllChildren(this._cryFrace);
            this._cryFrace = null;
            ObjectUtils.disposeObject(this.blackBm);
            this.blackBm = null;
            ObjectUtils.disposeObject(this.blackEyes);
            this.blackEyes = null;
            if (this._defaultBody)
            {
                ObjectUtils.disposeObject(this._defaultBody);
                this._defaultBody = null;
            };
            super.dispose();
            this._frameStartPoint = null;
            this._cryBmps = null;
        }

        private function drawSoul():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:Matrix;
            var _local_5:BitmapData;
            var _local_6:int;
            var _local_7:Rectangle;
            var _local_8:Number;
            var _local_1:Point = new Point(0, 0);
            if (_info.getShowSuits())
            {
                this._soulFace = new BitmapData(this._normalSuit.width, this._normalSuit.height, true, 0);
                _local_2 = 0;
                while (_local_2 < 4)
                {
                    _local_1.x = (_characterWidth * _local_2);
                    this._soulFace.copyPixels(this._lackHpSuit, _frames[36], _local_1, null, null, true);
                    _local_2++;
                };
            }
            else
            {
                this._soulFace = new BitmapData(this._faceBitmapData.width, this._faceBitmapData.height, true, 0);
                _local_3 = 0;
                _local_4 = new Matrix();
                _local_5 = new BitmapData(this._faceBitmapData.width, this._faceBitmapData.height, true, 0);
                _local_6 = 0;
                while (_local_6 < 4)
                {
                    _local_1.x = (_characterWidth * _local_6);
                    switch (_local_6)
                    {
                        case 0:
                            _local_3 = 0;
                            break;
                        case 1:
                            _local_3 = 10;
                            break;
                        case 2:
                            _local_3 = 14;
                            break;
                        case 3:
                            _local_3 = 17;
                            break;
                    };
                    _local_1.x = (_characterWidth * _local_6);
                    this._soulFace.copyPixels(this._faceBitmapData, _frames[_local_3], _local_1, null, null, true);
                    _local_6++;
                };
                _local_4.scale(0.75, 0.75);
                _local_1.x = (_local_1.y = 0);
                _local_5.draw(this._soulFace, _local_4, null, null, null, true);
                _local_7 = new Rectangle(0, 0, _characterWidth, _characterHeight);
                this._soulFace.fillRect(this._soulFace.rect, 0);
                _local_8 = 0;
                while (_local_8 < 4)
                {
                    _local_7.x = ((_local_8 * _characterWidth) * 0.75);
                    _local_1.x = ((_characterWidth * _local_8) + 7);
                    _local_1.y = 5;
                    this._soulFace.copyPixels(this._faceDownBitmapdata, _frames[36], new Point((_local_8 * _characterWidth), 0), null, null, true);
                    this._soulFace.copyPixels(_local_5, _local_7, _local_1, null, null, true);
                    this._soulFace.copyPixels(this._faceupBitmapData, _frames[36], new Point((_local_8 * _characterWidth), 0), null, null, true);
                    _local_8++;
                };
                _local_1.x = (_local_1.y = 0);
                this._soulFace.applyFilter(this._soulFace, this._soulFace.rect, _local_1, grayFilter);
                _local_5.dispose();
            };
        }

        private function drawBomd():void
        {
            var _local_1:BitmapData = new BitmapData(_body.width, _body.height, true, 0);
            _local_1.fillRect(new Rectangle(0, 0, _local_1.height, _local_1.height), 0);
            if (_info.getShowSuits())
            {
                _local_1.copyPixels(this._normalSuit, _frames[1], this._frameStartPoint, null, null, true);
            }
            else
            {
                _local_1.copyPixels(this._faceDownBitmapdata, _frames[1], this._frameStartPoint, null, null, true);
                _local_1.copyPixels(this._faceBitmapData, _frames[1], this._frameStartPoint, null, null, true);
                _local_1.copyPixels(this._faceupBitmapData, _frames[1], this._frameStartPoint, null, null, true);
            };
            this.drawBlack(_local_1);
            this.blackBm = new Bitmap(_local_1);
            this.blackBm.x = _body.x;
            this.blackBm.y = _body.y;
            if (this.blackEyes == null)
            {
                this.blackEyes = (ClassUtils.CreatInstance("asset.game.bombedAsset1") as MovieClip);
                this.blackEyes.x = 8;
                this.blackEyes.y = -10;
            };
        }

        override public function drawFrame(_arg_1:int, _arg_2:int=0, _arg_3:Boolean=true):void
        {
            var _local_4:BitmapData;
            if ((!(completed)))
            {
                return;
            };
            if (_arg_2 == 1)
            {
                _local_4 = this._faceDownBitmapdata;
            }
            else
            {
                if (_arg_2 == 2)
                {
                    _local_4 = this._lackHpFaceBitmapdata[this._specialType];
                }
                else
                {
                    if (_arg_2 == 3)
                    {
                        if (((this._currentAction == CRY) && (this._cryType > 0)))
                        {
                            _local_4 = this._tempCryFace;
                        }
                        else
                        {
                            _local_4 = this._faceBitmapData;
                        };
                    }
                    else
                    {
                        if (_arg_2 == 4)
                        {
                            _local_4 = this._faceupBitmapData;
                        }
                        else
                        {
                            if (_arg_2 == 5)
                            {
                                _local_4 = this._spBitmapData[this._specialType];
                            }
                            else
                            {
                                if (_arg_2 == 6)
                                {
                                    _local_4 = this._normalSuit;
                                }
                                else
                                {
                                    if (_arg_2 == 7)
                                    {
                                        _local_4 = this._lackHpSuit;
                                    }
                                    else
                                    {
                                        if (_arg_2 == 8)
                                        {
                                            _local_4 = this._soulFace;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (this._currentAction == SOUL)
            {
                if (this.closeEys < 4)
                {
                    _arg_1 = 1;
                }
                else
                {
                    if (Math.random() < 0.008)
                    {
                        this.closeEys = 0;
                    };
                };
                this.closeEys++;
            };
            if (_local_4 != null)
            {
                if (((_arg_1 < 0) || (_arg_1 >= _frames.length)))
                {
                    _arg_1 = 0;
                };
                _currentframe = _arg_1;
                if (_arg_3)
                {
                    _body.bitmapData.fillRect(this._rect, 0);
                };
                if (((this._currentAction == CRY) && ((_arg_2 == 2) || (_arg_2 == 3))))
                {
                    _body.bitmapData.copyPixels(_local_4, _frames[(_arg_1 - this._cryTypes[this._cryType])], this._frameStartPoint, null, null, true);
                }
                else
                {
                    _body.bitmapData.copyPixels(_local_4, _frames[_arg_1], this._frameStartPoint, null, null, true);
                };
            };
        }


    }
}//package ddt.view.character

