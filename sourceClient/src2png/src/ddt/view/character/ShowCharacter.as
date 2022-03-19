// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ShowCharacter

package ddt.view.character
{
    import flash.geom.Point;
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.player.PlayerInfo;
    import ddt.events.PlayerPropertyEvent;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import ddt.manager.ItemManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ShowCharacter extends BaseCharacter 
    {

        public static const STAND:String = "stand";
        public static const WIN:String = "win";
        public static const LOST:String = "lost";
        public static const BIG_WIDTH:int = 250;
        public static const BIG_HEIGHT:int = 342;

        private var _showLight:Boolean;
        private var _lightPos:Point;
        private var _light1:MovieClip;
        private var _light2:MovieClip;
        private var _light01:BaseLightLayer;
        private var _light02:SinpleLightLayer;
        private var _loading:MovieClip;
        private var _showGun:Boolean;
        private var _characterWithWeapon:BitmapData;
        private var _characterWithoutWeapon:BitmapData;
        private var _wing:MovieClip;
        private var _staticBmp:Sprite;
        private var _currentAction:String;
        private var _recordNimbus:int;
        private var _needMultiFrame:Boolean;
        private var _showWing:Boolean = true;
        private var _playAnimation:Boolean = true;
        private var _wpCrtBmd:BitmapData;
        private var _winCrtBmd:BitmapData;

        public function ShowCharacter(_arg_1:PlayerInfo, _arg_2:Boolean=true, _arg_3:Boolean=true, _arg_4:Boolean=false)
        {
            super(_arg_1, false);
            this._showGun = _arg_2;
            this._showLight = _arg_3;
            this._lightPos = new Point(0, 0);
            this._needMultiFrame = _arg_4;
            this._loading = (ComponentFactory.Instance.creat("asset.core.character.FigureBgAsset") as MovieClip);
            this._loading.x = 0;
            this._loading.y = 0;
            _container.addChild(this._loading);
            this._currentAction = STAND;
        }

        public function setLoadPos(_arg_1:Point):void
        {
            this._loading.x = _arg_1.x;
            this._loading.y = _arg_1.y;
        }

        override protected function initEvent():void
        {
            super.initEvent();
            _info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChangeII);
        }

        private function __propertyChangeII(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties[PlayerInfo.NIMBUS])
            {
                this.updateLight();
            };
        }

        override public function set showGun(_arg_1:Boolean):void
        {
            if (_arg_1 == this._showGun)
            {
                return;
            };
            this._showGun = _arg_1;
            this.updateCharacter();
        }

        public function set showWing(_arg_1:Boolean):void
        {
            if (this._wing)
            {
                this._wing.visible = _arg_1;
            };
            if (_arg_1 == this._showWing)
            {
                return;
            };
            this._showWing = _arg_1;
        }

        override protected function initLoader():void
        {
            if (_info == null)
            {
                return;
            };
            _loader = _factory.createLoader(_info, CharacterLoaderFactory.SHOW);
            ShowCharacterLoader(_loader).needMultiFrames = this._needMultiFrame;
        }

        override public function set scaleX(_arg_1:Number):void
        {
            if (_arg_1 == -1)
            {
                this._loading.scaleX = 1;
            };
            super.scaleX = (_dir = _arg_1);
            if ((!(_loadCompleted)))
            {
                this._loading.loading1.visible = (_arg_1 == 1);
                this._loading.loading2.visible = (!(this._loading.loading1.visible));
            };
            _container.x = ((_arg_1 < 0) ? -(_characterWidth) : 0);
        }

        override public function setShowLight(_arg_1:Boolean, _arg_2:Point=null):void
        {
            if (((this._showLight == _arg_1) && (this._lightPos == _arg_2)))
            {
                return;
            };
            this._showLight = _arg_1;
            if (_arg_1)
            {
                if (_arg_2 == null)
                {
                    _arg_2 = new Point(0, 0);
                };
                this._lightPos = _arg_2;
            };
            this.updateLight();
        }

        private function stopMovieClip(_arg_1:MovieClip):void
        {
            var _local_2:int;
            if (_arg_1)
            {
                _arg_1.gotoAndStop(1);
                if (_arg_1.numChildren > 0)
                {
                    _local_2 = 0;
                    while (_local_2 < _arg_1.numChildren)
                    {
                        this.stopMovieClip((_arg_1.getChildAt(_local_2) as MovieClip));
                        _local_2++;
                    };
                };
            };
        }

        private function playMovieClip(_arg_1:MovieClip):void
        {
            var _local_2:int;
            if (_arg_1)
            {
                _arg_1.gotoAndPlay(1);
                if (_arg_1.numChildren > 0)
                {
                    _local_2 = 0;
                    while (_local_2 < _arg_1.numChildren)
                    {
                        this.playMovieClip((_arg_1.getChildAt(_local_2) as MovieClip));
                        _local_2++;
                    };
                };
            };
        }

        private function stopWing():void
        {
            this.stopMovieClip(this._wing);
        }

        public function stopAnimation():void
        {
            this._playAnimation = false;
            this.stopAllMoiveClip();
        }

        public function playAnimation():void
        {
            this._playAnimation = true;
            this.playAllMoiveClip();
        }

        private function stopAllMoiveClip():void
        {
            this.stopMovieClip(this._light1);
            this.stopMovieClip(this._light2);
            this.stopWing();
        }

        private function playAllMoiveClip():void
        {
            this.playMovieClip(this._light1);
            this.playMovieClip(this._light2);
            this.playMovieClip(this._wing);
        }

        private function restoreAnimationState():void
        {
            if (this._playAnimation)
            {
                this.playAllMoiveClip();
            }
            else
            {
                this.stopAllMoiveClip();
            };
        }

        private function drawBitmapWithWingAndLight():void
        {
            var _local_1:int;
            var _local_3:DisplayObjectContainer;
            var _local_4:int;
            if (((_container == null) || (!(_loadCompleted))))
            {
                return;
            };
            this.stopAllMoiveClip();
            _local_1 = _container.x;
            var _local_2:int = _container.y;
            _local_3 = _container.parent;
            _local_4 = _local_3.getChildIndex(_container);
            var _local_5:Rectangle = _container.getBounds(_container);
            var _local_6:Sprite = new Sprite();
            _local_3.removeChild(_container);
            _container.x = (-(_local_5.x) * _container.scaleX);
            _container.y = (-(_local_5.y) * _container.scaleX);
            _local_6.addChild(_container);
            var _local_7:BitmapData = new BitmapData(_local_6.width, _local_6.height, true, 0);
            _local_7.draw(_local_6);
            var _local_8:Bitmap = new Bitmap(_local_7, "auto", true);
            _local_6.removeChild(_container);
            _local_6.addChild(_local_8);
            _container.x = _local_1;
            _container.y = _local_2;
            _local_3.addChildAt(_container, _local_4);
            _local_6.x = _local_6.width;
            this._staticBmp = _local_6;
            this.restoreAnimationState();
        }

        public function getShowBitmapBig():DisplayObject
        {
            if (this._staticBmp == null)
            {
                this.drawBitmapWithWingAndLight();
            };
            return (this._staticBmp);
        }

        public function resetShowBitmapBig():void
        {
            if (((this._staticBmp) && (this._staticBmp.parent)))
            {
                this._staticBmp.parent.removeChild(this._staticBmp);
            };
            this._staticBmp = null;
        }

        private function updateLight():void
        {
            if (_info == null)
            {
                return;
            };
            if ((!(LightVible)))
            {
                return;
            };
            if (((this._showLight) && (this.currentAction == STAND)))
            {
                this._recordNimbus = _info.Nimbus;
                if (_info.getHaveLight())
                {
                    if (this._light02)
                    {
                        this._light02.dispose();
                    };
                    this._light02 = new SinpleLightLayer(_info.Sinple);
                    this._light02.load(this.callBack02);
                }
                else
                {
                    if (this._light02)
                    {
                        this._light02.dispose();
                    };
                    if (((this._light2) && (this._light2.parent)))
                    {
                        this._light2.parent.removeChild(this._light2);
                    };
                    this._light2 = null;
                };
                if (_info.getHaveCircle())
                {
                    if (this._light01)
                    {
                        this._light01.dispose();
                    };
                    this._light01 = new BaseLightLayer(_info.Nimbus);
                    this._light01.load(this.callBack01);
                }
                else
                {
                    if (this._light01)
                    {
                        this._light01.dispose();
                    };
                    if (((this._light1) && (this._light1.parent)))
                    {
                        this._light1.parent.removeChild(this._light1);
                    };
                    this._light1 = null;
                };
            }
            else
            {
                if (this._light01)
                {
                    this._light01.dispose();
                };
                if (this._light02)
                {
                    this._light02.dispose();
                };
                if (((this._light1) && (this._light1.parent)))
                {
                    this._light1.parent.removeChild(this._light1);
                };
                if (((this._light2) && (this._light2.parent)))
                {
                    this._light2.parent.removeChild(this._light2);
                };
                this._light1 = null;
                this._light2 = null;
            };
        }

        private function callBack01(_arg_1:BaseLightLayer):void
        {
            if (((this._light1) && (this._light1.parent)))
            {
                this._light1.parent.removeChild(this._light1);
            };
            this._light1 = (_arg_1.getContent() as MovieClip);
            if (this._light1 != null)
            {
                _container.addChildAt(this._light1, 0);
                this._light1.x = (this._lightPos.x + 47);
                this._light1.y = (this._lightPos.y + 65);
            };
            this.drawBitmapWithWingAndLight();
            this.restoreAnimationState();
        }

        private function callBack02(_arg_1:SinpleLightLayer):void
        {
            if (((this._light2) && (this._light2.parent)))
            {
                this._light2.parent.removeChild(this._light2);
            };
            this._light2 = (_arg_1.getContent() as MovieClip);
            if (this._light2 != null)
            {
                _container.addChild(this._light2);
                if (_info.Sinple == 100)
                {
                    this._light2.x = -33;
                    this._light2.y = 115;
                }
                else
                {
                    if (_info.Sinple == 200)
                    {
                        this._light2.x = -22;
                        this._light2.y = 103;
                    }
                    else
                    {
                        if (_info.Sinple == 300)
                        {
                            this._light2.x = -26;
                            this._light2.y = 77;
                        }
                        else
                        {
                            if (_info.Sinple == 400)
                            {
                                this._light2.x = -29;
                                this._light2.y = 98;
                            }
                            else
                            {
                                if (_info.Sinple == 500)
                                {
                                    this._light2.x = -39;
                                    this._light2.y = 98;
                                };
                            };
                        };
                    };
                };
            };
            this.drawBitmapWithWingAndLight();
            this.restoreAnimationState();
        }

        private function updateCharacter():void
        {
            if (((!(_loader == null)) && (!(_loader.getContent()[0] == null))))
            {
                this.__loadComplete(_loader);
            }
            else
            {
                this.setContent();
            };
        }

        public function get characterWithWeapon():BitmapData
        {
            return (this._characterWithWeapon);
        }

        override protected function setContent():void
        {
            var _local_1:Array;
            if (_loader != null)
            {
                _local_1 = _loader.getContent();
                if (((this._characterWithWeapon) && (!(this._characterWithWeapon == _local_1[0]))))
                {
                    this._characterWithWeapon.dispose();
                };
                if (((this._characterWithoutWeapon) && (!(this._characterWithoutWeapon == _local_1[1]))))
                {
                    this._characterWithoutWeapon.dispose();
                };
                this._characterWithWeapon = _local_1[0];
                this._characterWithoutWeapon = _local_1[1];
                if (this._wpCrtBmd)
                {
                    this._wpCrtBmd.dispose();
                };
                this._wpCrtBmd = null;
                if (this._winCrtBmd)
                {
                    this._winCrtBmd.dispose();
                };
                this._winCrtBmd = null;
                if (((this._wing) && (this._wing.parent)))
                {
                    this._wing.parent.removeChild(this._wing);
                };
                this._wing = _local_1[2];
            };
            if (this._showGun)
            {
                characterBitmapdata = this._characterWithWeapon;
            }
            else
            {
                characterBitmapdata = this._characterWithoutWeapon;
            };
            this.doAction(this._currentAction);
            this.drawBitmapWithWingAndLight();
        }

        public function get charaterWithoutWeapon():BitmapData
        {
            if (this._wpCrtBmd == null)
            {
                this._wpCrtBmd = new BitmapData(_characterWidth, _characterHeight, true, 0);
                this._wpCrtBmd.copyPixels(this._characterWithoutWeapon, _frames[0], new Point(0, 0));
            };
            return (this._wpCrtBmd);
        }

        public function get winCharater():BitmapData
        {
            if (this._winCrtBmd == null)
            {
                this._winCrtBmd = new BitmapData(_characterWidth, _characterHeight, true, 0);
                this._winCrtBmd.copyPixels(_characterBitmapdata, _frames[1], new Point(0, 0));
            };
            return (this._winCrtBmd);
        }

        private function updateWing():void
        {
            if (((!(this._showWing)) || (this._wing == null)))
            {
                if (((!(this._showWing)) && (this._wing)))
                {
                    this._wing.visible = false;
                };
                return;
            };
            var _local_1:int = _container.getChildIndex(_body);
            _local_1 = ((_local_1 < 1) ? 0 : (_local_1 - 1));
            var _local_2:Array = _info.Style.split(",");
            var _local_3:Boolean = (!(ItemManager.Instance.getTemplateById(int(_local_2[8].split("|")[0])).Property1 == "1"));
            if (((_info.getSuitsType() == 1) && (_local_3)))
            {
                this._wing.y = -40;
            }
            else
            {
                this._wing.y = 2;
                this._wing.x = -1;
            };
            if (_info.wingHide)
            {
                if (this._wing.parent != null)
                {
                    this._wing.parent.removeChild(this._wing);
                };
            }
            else
            {
                _container.addChild(this._wing);
            };
            this.sortIndex();
        }

        private function sortIndex():void
        {
            if (this._light1 != null)
            {
                _container.addChild(this._light1);
            };
            if (((!(this._wing == null)) && (!(_info.wingHide))))
            {
                _container.addChild(this._wing);
            };
            if (_body != null)
            {
                _container.addChild(_body);
            };
            if (this._light2 != null)
            {
                _container.addChild(this._light2);
            };
        }

        public function removeWing():void
        {
            if (((this._wing) && (this._wing.parent)))
            {
                this._wing.parent.removeChild(this._wing);
            };
        }

        override protected function __loadComplete(_arg_1:ICharacterLoader):void
        {
            if (this._loading != null)
            {
                if (this._loading.parent)
                {
                    this._loading.parent.removeChild(this._loading);
                };
            };
            super.__loadComplete(_arg_1);
            this.updateLight();
        }

        override public function doAction(_arg_1:*):void
        {
            this._currentAction = _arg_1;
            if (_info.getSuitsType() == 1)
            {
                _body.y = -13;
            }
            else
            {
                _body.y = 0;
            };
            switch (this._currentAction)
            {
                case ShowCharacter.STAND:
                    drawFrame(0);
                    this.updateWing();
                    return;
                case ShowCharacter.WIN:
                    drawFrame(1);
                    this.removeWing();
                    return;
                case ShowCharacter.LOST:
                    drawFrame(2);
                    this.removeWing();
                    return;
            };
        }

        override protected function initSizeAndPics():void
        {
            setCharacterSize(BIG_WIDTH, BIG_HEIGHT);
            setPicNum(1, 2);
        }

        override public function show(_arg_1:Boolean=true, _arg_2:int=1, _arg_3:Boolean=true):void
        {
            super.show(_arg_1, _arg_2, _arg_3);
            if (_arg_3)
            {
                _body.width = BaseCharacter.BASE_WIDTH;
                _body.height = BaseCharacter.BASE_HEIGHT;
                _body.cacheAsBitmap = false;
            }
            else
            {
                _body.width = BIG_WIDTH;
                _body.height = BIG_HEIGHT;
                _body.cacheAsBitmap = false;
            };
        }

        public function showWithSize(_arg_1:Boolean=true, _arg_2:int=1, _arg_3:Number=120, _arg_4:Number=165):void
        {
            super.show(_arg_1, _arg_2);
            _body.width = _arg_3;
            _body.height = _arg_4;
            _body.cacheAsBitmap = false;
        }

        override public function get currentAction():*
        {
            return (this._currentAction);
        }

        override public function dispose():void
        {
            if (_info)
            {
                _info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChangeII);
            };
            if (this._light01)
            {
                this._light01.dispose();
            };
            this._light01 = null;
            if (this._light02)
            {
                this._light02.dispose();
            };
            this._light02 = null;
            if (((this._light2) && (this._light2.parent)))
            {
                this._light2.parent.removeChild(this._light2);
            };
            this._light2 = null;
            if (((this._light1) && (this._light1.parent)))
            {
                this._light1.parent.removeChild(this._light1);
            };
            this._light1 = null;
            super.dispose();
            if (this._characterWithoutWeapon)
            {
                this._characterWithoutWeapon.dispose();
            };
            this._characterWithoutWeapon = null;
            if (this._staticBmp)
            {
                ObjectUtils.disposeAllChildren(this._staticBmp);
                ObjectUtils.disposeObject(this._staticBmp);
                this._staticBmp = null;
            };
            if (this._characterWithWeapon)
            {
                this._characterWithWeapon.dispose();
            };
            this._characterWithWeapon = null;
            if (((this._wing) && (this._wing.parent)))
            {
                this._wing.parent.removeChild(this._wing);
            };
            this._wing = null;
            if (this._winCrtBmd)
            {
                this._winCrtBmd.dispose();
            };
            this._winCrtBmd = null;
            if (this._wpCrtBmd)
            {
                this._wpCrtBmd.dispose();
            };
            this._wpCrtBmd = null;
            if (((this._loading) && (this._loading.parent)))
            {
                this._loading.parent.removeChild(this._loading);
            };
            this._loading = null;
            this._lightPos = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.character

