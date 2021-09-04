package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import worldboss.player.WorldBossActiveTimeInfo;
   
   public class WorldBossTimeAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<WorldBossActiveTimeInfo>;
      
      public function WorldBossTimeAnalyzer(param1:Function)
      {
         super(param1);
         this.list = new Vector.<WorldBossActiveTimeInfo>();
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:WorldBossActiveTimeInfo = null;
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_..item;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new WorldBossActiveTimeInfo();
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_);
            this.list.push(_loc5_);
         }
         onAnalyzeComplete();
      }
   }
}
