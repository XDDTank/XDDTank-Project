// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.BloodNumberCreater

package game.view.effects
{
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import com.pickgliss.ui.ComponentFactory;
    import __AS3__.vec.*;

    public class BloodNumberCreater 
    {

        public var greenData:Vector.<BitmapData>;
        public var redData:Vector.<BitmapData>;
        public var whiteData:Vector.<BitmapData>;
        public var redYellowData:Vector.<BitmapData>;
        public var blueData:Vector.<BitmapData>;
        public var damageData:Vector.<BitmapData>;
        public var addIconData:BitmapData;

        public function BloodNumberCreater()
        {
            this.init();
        }

        private function init():void
        {
            this.redData = new Vector.<BitmapData>();
            this.greenData = new Vector.<BitmapData>();
            this.whiteData = new Vector.<BitmapData>();
            this.redYellowData = new Vector.<BitmapData>();
            this.blueData = new Vector.<BitmapData>();
            this.damageData = new Vector.<BitmapData>();
            var _local_1:int;
            while (_local_1 < 10)
            {
                this.redData.push(ComponentFactory.Instance.creatBitmapData((("asset.game.bloodNUm" + _local_1) + "Asset")));
                this.greenData.push(ComponentFactory.Instance.creatBitmapData((("asset.game.bloodNUma" + _local_1) + "Asset")));
                this.redYellowData.push(ComponentFactory.Instance.creatBitmapData((("asset.game.bloodNUms" + _local_1) + "Asset")));
                this.blueData.push(ComponentFactory.Instance.creatBitmapData((("asset.game.bloodNUmg" + _local_1) + "Asset")));
                this.whiteData.push(ComponentFactory.Instance.creatBitmapData(("asset.game.hitsNum" + _local_1)));
                this.damageData.push(ComponentFactory.Instance.creatBitmapData(("asset.game.damageNum" + _local_1)));
                _local_1++;
            };
            this.addIconData = ComponentFactory.Instance.creatBitmapData("asset.game.addBloodIconAsset");
        }

        public function dispose():void
        {
            var _local_1:int;
            while (_local_1 < 10)
            {
                this.redData[_local_1].dispose();
                this.redData[_local_1] = null;
                this.greenData[_local_1].dispose();
                this.greenData[_local_1] = null;
                this.blueData[_local_1].dispose();
                this.blueData[_local_1] = null;
                this.redYellowData[_local_1].dispose();
                this.redYellowData[_local_1] = null;
                this.whiteData[_local_1].dispose();
                this.whiteData[_local_1] = null;
                this.damageData[_local_1].dispose();
                this.damageData[_local_1] = null;
                _local_1++;
            };
        }


    }
}//package game.view.effects

