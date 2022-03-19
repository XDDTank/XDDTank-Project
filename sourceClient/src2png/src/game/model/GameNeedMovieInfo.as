// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.GameNeedMovieInfo

package game.model
{
    import ddt.manager.PathManager;
    import ddt.manager.LoadBombManager;
    import com.pickgliss.utils.StringUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;

    public class GameNeedMovieInfo 
    {

        public var type:int;
        public var path:String;
        private var _classPath:String;
        public var bombId:int;


        public function get classPath():String
        {
            return (this._classPath);
        }

        public function set classPath(_arg_1:String):void
        {
            this._classPath = _arg_1;
            var _local_2:String = this.classPath.replace("tank.resource.bombs.Bomb", "");
            this.bombId = int(_local_2);
        }

        public function get filePath():String
        {
            var _local_1:String = "";
            if (this.type == 2)
            {
                _local_1 = PathManager.SITE_MAIN;
            };
            return (_local_1 + this.path);
        }

        public function startBomb():void
        {
            LoadBombManager.Instance.loadLivingBomb(this.bombId);
        }

        public function startLoad():void
        {
            if (((StringUtils.endsWith(this.filePath.toLocaleLowerCase(), "jpg")) || (StringUtils.endsWith(this.filePath.toLocaleLowerCase(), "png"))))
            {
                LoadResourceManager.instance.creatAndStartLoad(this.filePath, BaseLoader.BITMAP_LOADER);
            }
            else
            {
                if (this.type == 2)
                {
                    LoadResourceManager.instance.creatAndStartLoad(this.filePath, BaseLoader.MODULE_LOADER);
                };
                if (this.type == 1)
                {
                    this.startBomb();
                };
            };
        }


    }
}//package game.model

