package com.smp.guestbook;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;

public class BlobHelper
{
	public static boolean doesBlobExist(String key, BlobstoreService blobstoreService)
	{
		boolean blobExists = true;
		try {
			blobstoreService.fetchData(new BlobKey(key), 0L, 10L);
		} catch (IllegalArgumentException e) {
			blobExists = false;
		}
		
		return blobExists;
	}
}
