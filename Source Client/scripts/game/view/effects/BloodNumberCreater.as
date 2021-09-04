package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.BitmapData;
   
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
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.redData = new Vector.<BitmapData>();
         this.greenData = new Vector.<BitmapData>();
         this.whiteData = new Vector.<BitmapData>();
         this.redYellowData = new Vector.<BitmapData>();
         this.blueData = new Vector.<BitmapData>();
         this.damageData = new Vector.<BitmapData>();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.redData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUm" + _loc1_ + "Asset"));
            this.greenData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUma" + _loc1_ + "Asset"));
            this.redYellowData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUms" + _loc1_ + "Asset"));
            this.blueData.push(ComponentFactory.Instance.creatBitmapData("asset.game.bloodNUmg" + _loc1_ + "Asset"));
            this.whiteData.push(ComponentFactory.Instance.creatBitmapData("asset.game.hitsNum" + _loc1_));
            this.damageData.push(ComponentFactory.Instance.creatBitmapData("asset.game.damageNum" + _loc1_));
            _loc1_++;
         }
         this.addIconData = ComponentFactory.Instance.creatBitmapData("asset.game.addBloodIconAsset");
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this.redData[_loc1_].dispose();
            this.redData[_loc1_] = null;
            this.greenData[_loc1_].dispose();
            this.greenData[_loc1_] = null;
            this.blueData[_loc1_].dispose();
            this.blueData[_loc1_] = null;
            this.redYellowData[_loc1_].dispose();
            this.redYellowData[_loc1_] = null;
            this.whiteData[_loc1_].dispose();
            this.whiteData[_loc1_] = null;
            this.damageData[_loc1_].dispose();
            this.damageData[_loc1_] = null;
            _loc1_++;
         }
      }
   }
}
