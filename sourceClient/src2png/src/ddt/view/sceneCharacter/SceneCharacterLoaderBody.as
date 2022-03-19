﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterLoaderBody

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.ItemManager;
    import flash.display.BlendMode;
    import ddt.view.character.ILayer;
    import __AS3__.vec.*;

    public class SceneCharacterLoaderBody 
    {

        protected var _loaders:Vector.<SceneCharacterLayer>;
        protected var _recordStyle:Array;
        protected var _recordColor:Array;
        protected var _content:BitmapData;
        protected var _completeCount:int;
        protected var _playerInfo:PlayerInfo;
        protected var _sceneCharacterLoaderPath:String;
        protected var _isAllLoadSucceed:Boolean = true;
        protected var _callBack:Function;

        public function SceneCharacterLoaderBody(_arg_1:PlayerInfo, _arg_2:String=null)
        {
            this._playerInfo = _arg_1;
            this._sceneCharacterLoaderPath = _arg_2;
        }

        public function load(_arg_1:Function=null):void
        {
            this._callBack = _arg_1;
            if (((this._playerInfo == null) || (this._playerInfo.Style == null)))
            {
                return;
            };
            this.initLoaders();
            var _local_2:int = this._loaders.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._loaders[_local_3].load(this.layerComplete);
                _local_3++;
            };
        }

        protected function initLoaders():void
        {
            this._loaders = new Vector.<SceneCharacterLayer>();
            this._recordStyle = this._playerInfo.Style.split(",");
            this._recordColor = this._playerInfo.Colors.split(",");
            this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[0].split("|")[0])), this._recordColor[0], 1, this._playerInfo.Sex, this._sceneCharacterLoaderPath));
            this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[0].split("|")[0])), this._recordColor[0], 2, this._playerInfo.Sex, this._sceneCharacterLoaderPath));
        }

        protected function drawCharacter():void
        {
            var _local_1:Number = this._loaders[0].width;
            var _local_2:Number = this._loaders[0].height;
            if (((_local_1 == 0) || (_local_2 == 0)))
            {
                return;
            };
            this._content = new BitmapData(_local_1, _local_2, true, 0);
            var _local_3:uint;
            while (_local_3 < this._loaders.length)
            {
                if ((!(this._loaders[_local_3].isAllLoadSucceed)))
                {
                    this._isAllLoadSucceed = false;
                };
                this._content.draw(this._loaders[_local_3].getContent(), null, null, BlendMode.NORMAL);
                _local_3++;
            };
        }

        protected function layerComplete(_arg_1:ILayer):void
        {
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_3 < this._loaders.length)
            {
                if ((!(this._loaders[_local_3].isComplete)))
                {
                    _local_2 = false;
                };
                _local_3++;
            };
            if (_local_2)
            {
                this.drawCharacter();
                this.loadComplete();
            };
        }

        protected function loadComplete():void
        {
            if (this._callBack != null)
            {
                this._callBack(this, this._isAllLoadSucceed);
            };
        }

        public function getContent():Array
        {
            return ([this._content]);
        }

        public function dispose():void
        {
            if (this._loaders == null)
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < this._loaders.length)
            {
                this._loaders[_local_1].dispose();
                _local_1++;
            };
            this._loaders = null;
            this._recordStyle = null;
            this._recordColor = null;
            this._playerInfo = null;
            this._callBack = null;
            this._sceneCharacterLoaderPath = null;
        }


    }
}//package ddt.view.sceneCharacter
