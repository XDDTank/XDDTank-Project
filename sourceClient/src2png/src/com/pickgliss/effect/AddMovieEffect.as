// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.effect.AddMovieEffect

package com.pickgliss.effect
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import flash.display.InteractiveObject;
    import flash.display.DisplayObjectContainer;
    import __AS3__.vec.*;

    public class AddMovieEffect extends BaseEffect implements IEffect 
    {

        private var _movies:Vector.<DisplayObject>;
        private var _rectangles:Vector.<Rectangle>;
        private var _data:Array;

        public function AddMovieEffect(_arg_1:int)
        {
            super(_arg_1);
        }

        override public function initEffect(_arg_1:DisplayObject, _arg_2:Array):void
        {
            super.initEffect(_arg_1, _arg_2);
            this._data = _arg_2;
            this.creatMovie();
        }

        public function get movie():Vector.<DisplayObject>
        {
            return (this._movies);
        }

        override public function dispose():void
        {
            super.dispose();
            var _local_1:int;
            while (_local_1 < this._movies.length)
            {
                if ((this._movies[_local_1] is MovieClip))
                {
                    MovieClip(this._movies[_local_1]).stop();
                };
                if (this._movies[_local_1])
                {
                    ObjectUtils.disposeObject(this._movies[_local_1]);
                };
                _local_1++;
            };
            this._movies = null;
        }

        override public function play():void
        {
            super.play();
            var _local_1:int;
            while (_local_1 < this._movies.length)
            {
                if ((this._movies[_local_1] is MovieClip))
                {
                    MovieClip(this._movies[_local_1]).play();
                };
                if (_target.parent)
                {
                    _target.parent.addChild(this._movies[_local_1]);
                };
                this._movies[_local_1].x = _target.x;
                this._movies[_local_1].y = _target.y;
                if ((this._rectangles.length - 1) >= _local_1)
                {
                    this._movies[_local_1].x = (this._movies[_local_1].x + this._rectangles[_local_1].x);
                    this._movies[_local_1].y = (this._movies[_local_1].y + this._rectangles[_local_1].y);
                };
                _local_1++;
            };
        }

        override public function stop():void
        {
            super.stop();
            var _local_1:int;
            while (_local_1 < this._movies.length)
            {
                if ((this._movies[_local_1] is MovieClip))
                {
                    MovieClip(this._movies[_local_1]).stop();
                };
                if (this._movies[_local_1].parent)
                {
                    this._movies[_local_1].parent.removeChild(this._movies[_local_1]);
                };
                _local_1++;
            };
        }

        private function creatMovie():void
        {
            var _local_3:int;
            this._movies = new Vector.<DisplayObject>();
            this._rectangles = new Vector.<Rectangle>();
            var _local_1:int;
            while (_local_1 < this._data.length)
            {
                if ((this._data[_local_1] is DisplayObject))
                {
                    this._movies.push(this._data[_local_1]);
                }
                else
                {
                    if ((this._data[_local_1] is String))
                    {
                        this._movies.push(ComponentFactory.Instance.creat(this._data[_local_1]));
                    };
                };
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._data.length)
            {
                if ((this._data[_local_2] is Point))
                {
                    this._rectangles.push(new Rectangle(this._data[_local_2].x, this._data[_local_2].y, 0, 0));
                }
                else
                {
                    if ((this._data[_local_2] is Rectangle))
                    {
                        this._rectangles.push(this._data[_local_2]);
                    };
                };
                _local_2++;
            };
            _local_3 = 0;
            while (_local_3 < this._movies.length)
            {
                if ((this._movies[_local_3] is InteractiveObject))
                {
                    InteractiveObject(this._movies[_local_3]).mouseEnabled = false;
                };
                if ((this._movies[_local_3] is DisplayObjectContainer))
                {
                    DisplayObjectContainer(this._movies[_local_3]).mouseChildren = false;
                    DisplayObjectContainer(this._movies[_local_3]).mouseEnabled = false;
                };
                _local_3++;
            };
        }


    }
}//package com.pickgliss.effect

