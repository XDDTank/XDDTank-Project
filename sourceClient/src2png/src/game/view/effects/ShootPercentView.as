// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.ShootPercentView

package game.view.effects
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.greensock.TweenLite;
    import ddt.data.TweenVars;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import game.GameManager;
    import com.pickgliss.toplevel.StageReferance;
    import game.model.Living;
    import com.greensock.easing.Sine;
    import flash.utils.setTimeout;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.utils.clearTimeout;
    import com.pickgliss.utils.ObjectUtils;

    public class ShootPercentView extends Sprite implements Disposeable 
    {

        private var _type:int;
        private var _isAdd:Boolean;
        private var _isSelf:Boolean;
        private var _picBmp:Bitmap;
        private var _leftBlood:MovieClip;
        private var _rightBlood:MovieClip;
        private var _leftCritBlood:MovieClip;
        private var _rightCritBlood:MovieClip;
        private var _redBg:MovieClip;
        private var _setTimeoutId:uint;
        private var tween:TweenLite;

        public function ShootPercentView(_arg_1:int, _arg_2:int=1, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this._type = _arg_2;
            this._isAdd = _arg_3;
            this._isSelf = _arg_4;
            this._picBmp = this.getPercent(Math.abs(_arg_1));
        }

        public function play(_arg_1:int=0):void
        {
            var _local_2:int;
            var _local_3:Bitmap;
            var _local_4:Bitmap;
            var _local_5:Sprite;
            var _local_6:Bitmap;
            var _local_7:TweenVars;
            var _local_8:TweenVars;
            if (this._picBmp != null)
            {
                _local_2 = ((_arg_1 == 0) ? int((Math.random() * 2)) : _arg_1);
                if (this._type == 2)
                {
                    _local_3 = (ComponentFactory.Instance.creatBitmap("asset.game.CritAsset") as Bitmap);
                    if (_local_2 == 1)
                    {
                        this._leftCritBlood = (ClassUtils.CreatInstance("asset.game.LeftCritBlood") as MovieClip);
                        this._leftCritBlood.cons.consPic.addChild(_local_3);
                        this._leftCritBlood.cons.consNum.addChild(this._picBmp);
                        this.addChild(this._leftCritBlood);
                    }
                    else
                    {
                        this._rightCritBlood = (ClassUtils.CreatInstance("asset.game.RightCritBlood") as MovieClip);
                        this._rightCritBlood.cons.consPic.addChild(_local_3);
                        this._rightCritBlood.cons.consNum.addChild(this._picBmp);
                        this.addChild(this._rightCritBlood);
                    };
                    if (GameManager.Instance.isRed)
                    {
                        this._redBg = (ClassUtils.CreatInstance("asset.game.CritRedBg") as MovieClip);
                        StageReferance.stage.addChild(this._redBg);
                        GameManager.Instance.isRed = false;
                    };
                }
                else
                {
                    if (this._type == 20)
                    {
                        _local_4 = (ComponentFactory.Instance.creatBitmap("asset.game.CritHeadAsset") as Bitmap);
                        if (_local_2 == 1)
                        {
                            this._leftCritBlood = (ClassUtils.CreatInstance("asset.game.LeftCritBlood") as MovieClip);
                            this._leftCritBlood.cons.consPic.addChild(_local_4);
                            this._leftCritBlood.cons.consNum.addChild(this._picBmp);
                            this.addChild(this._leftCritBlood);
                        }
                        else
                        {
                            this._rightCritBlood = (ClassUtils.CreatInstance("asset.game.RightCritBlood") as MovieClip);
                            this._rightCritBlood.cons.consPic.addChild(_local_4);
                            this._rightCritBlood.cons.consNum.addChild(this._picBmp);
                            this.addChild(this._rightCritBlood);
                        };
                        if (GameManager.Instance.isRed)
                        {
                            this._redBg = (ClassUtils.CreatInstance("asset.game.CritRedBg") as MovieClip);
                            StageReferance.stage.addChild(this._redBg);
                            GameManager.Instance.isRed = false;
                        };
                    }
                    else
                    {
                        if (this._type == Living.PET_REDUCE)
                        {
                            _local_5 = new Sprite();
                            _local_6 = (ComponentFactory.Instance.creatBitmap("asset.game.petReduceAsset") as Bitmap);
                            _local_6.scaleX = (_local_6.scaleY = 0.6);
                            _local_6.y = (_local_6.y + 6);
                            _local_5.addChild(_local_6);
                            _local_5.addChild(this._picBmp);
                            this._picBmp.x = (this._picBmp.x + _local_6.width);
                            this.addChild(_local_5);
                            _local_7 = (ComponentFactory.Instance.creatCustomObject("settlement.tweenVars") as TweenVars);
                            this.tween = TweenLite.to(_local_5, _local_7.duration, {
                                "x":(_local_5.x + _local_7.x),
                                "y":(_local_5.y + _local_7.y),
                                "scaleX":_local_7.scaleX,
                                "scaleY":_local_7.scaleY,
                                "alpha":_local_7.alpha,
                                "ease":Sine.easeOut,
                                "onComplete":this.__onCompleteTween,
                                "onCompleteParams":[_local_5]
                            });
                        }
                        else
                        {
                            if (this._isAdd)
                            {
                                this.addChild(this._picBmp);
                                _local_8 = (ComponentFactory.Instance.creatCustomObject("settlement.tweenVars") as TweenVars);
                                this.tween = TweenLite.to(this._picBmp, _local_8.duration, {
                                    "x":(this._picBmp.x + _local_8.x),
                                    "y":(this._picBmp.y + _local_8.y),
                                    "scaleX":_local_8.scaleX,
                                    "scaleY":_local_8.scaleY,
                                    "alpha":_local_8.alpha,
                                    "ease":Sine.easeOut,
                                    "onComplete":this.__onCompleteTween,
                                    "onCompleteParams":[this._picBmp]
                                });
                            }
                            else
                            {
                                if (_local_2 == 1)
                                {
                                    this._leftBlood = (ClassUtils.CreatInstance("asset.game.LeftLoseBlood") as MovieClip);
                                    this._leftBlood.cons.addChild(this._picBmp);
                                    this.addChild(this._leftBlood);
                                }
                                else
                                {
                                    this._rightBlood = (ClassUtils.CreatInstance("asset.game.RightLoseBlood") as MovieClip);
                                    this._rightBlood.cons.addChild(this._picBmp);
                                    this.addChild(this._rightBlood);
                                };
                            };
                        };
                    };
                };
            };
            this._setTimeoutId = setTimeout(this.dispose, 2000);
        }

        private function __onCompleteTween(dis:DisplayObject):void
        {
            var tl:TweenLite;
            this.tween.kill();
            this.tween = null;
            tl = TweenLite.to(dis, 0.4, {
                "alpha":0,
                "onComplete":function ():void
                {
                    tl.kill();
                }
            });
        }

        public function getPercent(_arg_1:int):Bitmap
        {
            var _local_2:Array;
            var _local_8:BitmapData;
            var _local_9:BitmapData;
            if (_arg_1 > 99999999)
            {
                return (null);
            };
            _local_2 = new Array();
            _local_2 = [0, 0, 0, 0];
            var _local_3:Array = new Array();
            var _local_4:String = String(_arg_1);
            var _local_5:int = _local_4.length;
            if (this._isAdd)
            {
                _local_4 = (" " + _local_4);
                _local_5 = (_local_5 + 1);
                _local_8 = GameManager.Instance.numCreater.addIconData;
                _local_3.push(0);
                _local_2.push(_local_8);
            };
            var _local_6:int = ((this._isAdd) ? 1 : 0);
            while (_local_6 < _local_5)
            {
                if (this._isAdd)
                {
                    _local_9 = GameManager.Instance.numCreater.greenData[int(_local_4.charAt(_local_6))];
                }
                else
                {
                    if (this._isSelf)
                    {
                        _local_9 = GameManager.Instance.numCreater.redYellowData[int(_local_4.charAt(_local_6))];
                    }
                    else
                    {
                        if (this._type == 21)
                        {
                            _local_9 = GameManager.Instance.numCreater.blueData[int(_local_4.charAt(_local_6))];
                        }
                        else
                        {
                            _local_9 = GameManager.Instance.numCreater.redData[int(_local_4.charAt(_local_6))];
                        };
                    };
                };
                _local_3.push((_local_6 * 20));
                _local_2.push(_local_9);
                _local_6++;
            };
            _local_2 = this.returnNum(_local_2, _local_3);
            var _local_7:BitmapData = new BitmapData(_local_2[2], _local_2[3], true, 0);
            this._picBmp = new Bitmap(_local_7, "auto", true);
            _local_6 = 4;
            while (_local_6 < _local_2.length)
            {
                _local_7.copyPixels(_local_2[_local_6], new Rectangle(0, 0, _local_2[_local_6].width, _local_2[_local_6].height), new Point((_local_3[(_local_6 - 4)] - _local_2[0]), (_local_2[_local_6].rect.y - _local_2[1])), null, null, true);
                _local_6++;
            };
            this._picBmp.x = _local_2[0];
            this._picBmp.y = _local_2[1];
            _local_2 = null;
            this._picBmp.smoothing = true;
            return (this._picBmp);
        }

        private function returnNum(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_3:int = 4;
            while (_local_3 < _arg_1.length)
            {
                _arg_1[0] = ((_arg_1[0] > _arg_2[(_local_3 - 4)]) ? _arg_2[(_local_3 - 4)] : _arg_1[0]);
                _arg_1[1] = ((_arg_1[1] > _arg_1[_local_3].rect.y) ? _arg_1[_local_3].rect.y : _arg_1[1]);
                _arg_1[2] = ((_arg_1[2] > (_arg_1[_local_3].width + _arg_2[(_local_3 - 4)])) ? _arg_1[2] : (_arg_1[_local_3].width + _arg_2[(_local_3 - 4)]));
                _arg_1[3] = ((_arg_1[3] > (_arg_1[_local_3].height + _arg_1[_local_3].rect.y)) ? _arg_1[3] : (_arg_1[_local_3].height + _arg_1[_local_3].rect.y));
                _local_3++;
            };
            _arg_1[2] = (_arg_1[2] - _arg_1[0]);
            _arg_1[3] = (_arg_1[3] - _arg_1[1]);
            return (_arg_1);
        }

        public function dispose():void
        {
            clearTimeout(this._setTimeoutId);
            if (this._redBg)
            {
                this._redBg.stop();
                StageReferance.stage.removeChild(this._redBg);
                this._redBg = null;
            };
            if (this._picBmp)
            {
                TweenLite.killTweensOf(this._picBmp);
                ObjectUtils.disposeObject(this._picBmp);
                this._picBmp = null;
            };
            if (this._leftBlood)
            {
                this._leftBlood.stop();
                ObjectUtils.disposeObject(this._leftBlood);
                this._leftBlood = null;
            };
            if (this._rightBlood)
            {
                this._rightBlood.stop();
                ObjectUtils.disposeObject(this._rightBlood);
                this._rightBlood = null;
            };
            if (this._leftCritBlood)
            {
                this._leftCritBlood.stop();
                ObjectUtils.disposeObject(this._leftCritBlood);
                this._leftCritBlood = null;
            };
            if (this._rightCritBlood)
            {
                this._rightCritBlood.stop();
                ObjectUtils.disposeObject(this._leftCritBlood);
                this._rightCritBlood = null;
            };
            if (this.tween)
            {
                this.tween.kill();
                this.tween = null;
            };
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.effects

