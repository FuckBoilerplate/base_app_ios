require 'fileutils'

class StartFresh 

	def initialize 
		copyData
		copyDomain
		copyPresentation
	end

	def copyData 

		puts("Removing files in data layer")
		data = '../base-app-ios/data/'
	    Helper.removeDir(data+'sections/user_demo')
		puts("You'll need to remove /base-app-ios/data/sections/user_demo reference manually! :(")
		Helper.moveFileDeleting('DataModule.txt', data+'foundation/internal/di/DataModule.swift')
		Helper.moveFileDeleting('RestApi.txt', data+'foundation/net/RestApi.swift')
		Helper.moveFileDeleting('RestApiMoya.txt', data+'foundation/net/RestApiMoya.swift')
		Helper.moveFileDeleting('RxCacheProviders.txt', data+'foundation/cache/RxCacheProviders.swift')

		puts("Removing tests files")
		dataTest = '../base-app-iosTests/data/'
	    Helper.removeDir(dataTest+'net')
		puts("You'll need to remove /base-app-ios/data/net reference manually! :(")
	end

	def copyDomain

		puts("Removing files in domain layer")
		domain = '../base-app-ios/domain/'
	    Helper.removeDir(domain+'sections/user_demo')
		puts("You'll need to remove /base-app-ios/domain/user_demo reference manually! :(")
	    Helper.removeDir(domain+'sections/dashboard')
		puts("You'll need to remove /base-app-ios/domain/dashboard reference manually! :(")

	end

	def copyPresentation

		puts("Removing files in Presentation layer")
		presentation = '../base-app-ios/presentation/'
	    Helper.removeDir(presentation+'sections/user_demo')
		puts("You'll need to remove /base-app-ios/presentation/sections/user_demo reference manually! :(")
	    Helper.removeDir(presentation+'sections/dashboard')
		puts("You'll need to remove /base-app-ios/presentation/sections/dashboard reference manually! :(")
	    Helper.moveFileDeleting('PresentationModule.txt', presentation+'internal/di/PresentationModule.swift')

		Helper.moveFileDeleting('Wireframe.txt', presentation+'sections/Wireframe.swift')

		appPath = '../base-app-ios/'
		Helper.moveFileDeleting('AppDelegate.txt', appPath+'AppDelegate.swift')
		Helper.moveFileDeleting('README.md', appPath+'README.md')
		Helper.moveFileDeleting('LICENSE', appPath+'LICENSE')

		puts("Now UnitTests")
		presentationTest = '../base-app-iosTests/presentation/'
	    Helper.removeDir(presentationTest+'sections/user_demo')
		puts("You'll need to remove /base-app-iosTests/presentation/sections/user_demo reference manually! :(")
	    Helper.removeDir(presentationTest+'sections/dashboard')
		puts("You'll need to remove /base-app-iosTests/presentation/sections/dashboard reference manually! :(")
        
        Helper.removeDir('../.git')
	 	Helper.removeDir('../start_fresh')

	 	puts("Remember clean, remove deleted references/directories/files and build the project")
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
