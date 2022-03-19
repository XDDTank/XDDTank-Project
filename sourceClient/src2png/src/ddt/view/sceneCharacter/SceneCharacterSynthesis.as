// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterSynthesis

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import __AS3__.vec.*;

    public class SceneCharacterSynthesis 
    {

        private var _sceneCharacterSet:SceneCharacterSet;
        private var _frameBitmap:Vector.<Bitmap> = new Vector.<Bitmap>();
        private var _callBack:Function;

        public function SceneCharacterSynthesis(_arg_1:SceneCharacterSet, _arg_2:Function)
        {
            this._sceneCharacterSet = _arg_1;
            this._callBack = _arg_2;
            this.initialize();
        }

        private function initialize():void
        {
            this.characterSynthesis();
        }

        private function characterSynthesis():void
        {
            var _local_4:SceneCharacterItem;
            var _local_5:SceneCharacterItem;
            var _local_6:BitmapData;
            var _local_7:int;
            var _local_8:BitmapData;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Point;
            var _local_1:Matrix = new Matrix();
            var _local_2:Point = new Point(0, 0);
            var _local_3:Rectangle = new Rectangle();
            for each (_local_4 in this._sceneCharacterSet.dataSet)
            {
                if (_local_4.isRepeat)
                {
                    _local_6 = new BitmapData((_local_4.source.width * _local_4.repeatNumber), _local_4.source.height, true, 0);
                    _local_7 = 0;
                    while (_local_7 < _local_4.repeatNumber)
                    {
                        _local_1.tx = (_local_4.source.width * _local_7);
                        _local_6.draw(_local_4.source, _local_1);
                        _local_7++;
                    };
                    _local_4.source.dispose();
                    _local_4.source = null;
                    _local_4.source = new BitmapData(_local_6.width, _local_6.height, true, 0);
                    _local_4.source.draw(_local_6);
                    _local_6.dispose();
                    _local_6 = null;
                };
                if (((_local_4.points) && (_local_4.points.length > 0)))
                {
                    _local_8 = new BitmapData(_local_4.source.width, _local_4.source.height, true, 0);
                    _local_8.draw(_local_4.source);
                    _local_4.source.dispose();
                    _local_4.source = null;
                    _local_4.source = new BitmapData(_local_8.width, _local_8.height, true, 0);
                    _local_3.width = _local_4.cellWitdh;
                    _local_3.height = _local_4.cellHeight;
                    _local_9 = 0;
                    while (_local_9 < _local_4.rowNumber)
                    {
                        _local_10 = ((_local_4.isRepeat) ? _local_4.repeatNumber : _local_4.rowCellNumber);
                        _local_11 = 0;
                        while (_local_11 < _local_10)
                        {
                            _local_12 = _local_4.points[((_local_9 * _local_10) + _local_11)];
                            if (_local_12)
                            {
                                _local_2.x = ((_local_4.cellWitdh * _local_11) + _local_12.x);
                                _local_2.y = ((_local_4.cellHeight * _local_9) + _local_12.y);
                                _local_3.x = (_local_4.cellWitdh * _local_11);
                                _local_3.y = (_local_4.cellHeight * _local_9);
                                _local_4.source.copyPixels(_local_8, _local_3, _local_2);
                            }
                            else
                            {
                                _local_2.x = (_local_3.x = (_local_4.cellWitdh * _local_11));
                                _local_2.y = (_local_3.y = (_local_4.cellHeight * _local_9));
                                _local_4.source.copyPixels(_local_8, _local_3, _local_2);
                            };
                            _local_11++;
                        };
                        _local_9++;
                    };
                    _local_8.dispose();
                    _local_8 = null;
                };
            };
            for each (_local_5 in this._sceneCharacterSet.dataSet)
            {
                this.characterGroupDraw(_local_5);
            };
            this.characterDraw();
        }

        private function characterGroupDraw(_arg_1:SceneCharacterItem):void
        {
            var _local_2:SceneCharacterItem;
            for each (_local_2 in this._sceneCharacterSet.dataSet)
            {
                if (((_arg_1.groupType == _local_2.groupType) && (!(_local_2.type == _arg_1.type))))
                {
                    _arg_1.source.draw(_local_2.source);
                    _arg_1.rowNumber = ((_local_2.rowNumber > _arg_1.rowNumber) ? _local_2.rowNumber : _arg_1.rowNumber);
                    _arg_1.rowCellNumber = ((_local_2.rowCellNumber > _arg_1.rowCellNumber) ? _local_2.rowCellNumber : _arg_1.rowCellNumber);
                    this._sceneCharacterSet.dataSet.splice(this._sceneCharacterSet.dataSet.indexOf(_local_2), 1);
                };
            };
        }

        private function characterDraw():void
        {
            var _local_1:BitmapData;
            var _local_2:SceneCharacterItem;
            var _local_3:int;
            var _local_4:int;
            for each (_local_2 in this._sceneCharacterSet.dataSet)
            {
                _local_3 = 0;
                while (_local_3 < _local_2.rowNumber)
                {
                    _local_4 = 0;
                    while (_local_4 < _local_2.rowCellNumber)
                    {
                        _local_1 = new BitmapData(_local_2.cellWitdh, _local_2.cellHeight, true, 0);
                        _local_1.copyPixels(_local_2.source, new Rectangle((_local_4 * _local_2.cellWitdh), (_local_2.cellHeight * _local_3), _local_2.cellWitdh, _local_2.cellHeight), new Point(0, 0));
                        this._frameBitmap.push(new Bitmap(_local_1));
                        _local_4++;
                    };
                    _local_3++;
                };
            };
            if (this._callBack != null)
            {
                this._callBack(this._frameBitmap);
            };
        }

        public function dispose():void
        {
            if (this._sceneCharacterSet)
            {
                this._sceneCharacterSet.dispose();
            };
            this._sceneCharacterSet = null;
            while (((this._frameBitmap) && (this._frameBitmap.length > 0)))
            {
                this._frameBitmap[0].bitmapData.dispose();
                this._frameBitmap[0].bitmapData = null;
                this._frameBitmap.shift();
            };
            this._frameBitmap = null;
            this._callBack = null;
        }


    }
}//package ddt.view.sceneCharacter

