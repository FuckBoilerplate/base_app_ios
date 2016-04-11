require 'fileutils'

class StartFresh 

	def initialize 
		copyData
		copyDomain
		copyPresentation
	end

	def copyData 

		data = '../base-app-ios/data/'
	    Helper.removeDir(data+'sections/user_demo')
		Helper.moveFileDeleting('DataModule.txt', data+'internal/di/DataModule.swift')
		Helper.moveFileDeleting('RestApi.txt', data+'net/RestApi.swift')
		Helper.moveFileDeleting('RestApiMoya.txt', data+'RestApiMoya.swift')
		Helper.moveFileDeleting('RxCacheProviders.txt', data+'storage/RxCacheProviders.swift')

		dataTest = '../base-app-iosTests/data/'
	    Helper.removeDir(dataTest+'user_demo')
	    Helper.removeDir(dataTest+'net')
	end

	def copyDomain

		domain = '../base-app-ios/domain/'
	    Helper.removeDir(domain+'sections/user_demo')
	    Helper.removeDir(domain+'sections/dashboard')
		Helper.moveFileDeleting('DomainModule.txt', domain+'internal/di/DomainModule.swift')
	    Helper.moveFileDeleting('Wireframe.txt', domain+'sections/Wireframe.swift')
	    Helper.moveFileDeleting('LaunchPresenter.txt', domain+'sections/launch/LaunchPresenter.swift')

		domainTest = '../base-app-iosTests/domain/'
	    Helper.removeDir(domainTest+'sections/user_demo')
	    Helper.removeDir(domainTest+'sections/dashboard')
	end

	def copyPresentation

		presentation = '../base-app-ios/presentation/'
	    Helper.removeDir(presentation+'sections/user_demo')
	    Helper.removeDir(presentation+'sections/dashboard')
	    Helper.moveFileDeleting('PresentationModule.txt', presentation+'internal/di/PresentationModule.swift')
	    Helper.moveFileDeleting('DomainPresentationModule.txt', presentation+'internal/di/DomainPresentationModule.swift')

		Helper.moveFileDeleting('WireframeDomain.txt', presentation+'sections/WireframeDomain.swift')

		appPath = '../base-app-ios/'
		Helper.moveFileDeleting('AppDelegate.txt', appPath+'AppDelegate.swift')
		Helper.moveFileDeleting('README.md', appPath+'README.md')
		Helper.moveFileDeleting('LICENSE', appPath+'LICENSE')

		presentationTest = '../base-app-iosTests/presentation/'
	    Helper.removeDir(presentationTest+'sections/user_demo')
	    Helper.removeDir(presentationTest+'sections/dashboard')
        
        Helper.removeDir('../.git')
	 	Helper.removeDir('../start_fresh')

	 	puts("Remember clean, remove deleted directories/files and build the project")

	end

end

class Helper

	def self.removeDir(path)
		FileUtils.rm_rf(path, :secure=>true)
	end

	def self.moveFileDeleting(source, destination)
		fileSrc = File.read(source)
		File.open(destination,"w") do |file|
		    file.puts fileSrc
		    removeDir(source)
		end
	end

end

# Runs StartFresh
StartFresh.new
